"use client"

import { useEffect, useState, useRef, useCallback } from "react"
import { Button } from "@/components/ui/button"

const BIRTHDAY_MESSAGE = "HAPPY BIRTHDAY BELLA"

const MATRIX_CHARS = [
  "0",
  "1",
  "2",
  "サ",
  "タ",
  "カ",
  "ナ",
  "ハ",
  "マ",
  "ヤ",
  "ラ",
  "ワ",
  "ガ",
  "ザ",
  "ダ",
  "バ",
  "パ",
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
]

interface MatrixChar {
  char: string
  x: number
  y: number
  opacity: number
  settled: boolean
  targetChar?: string
  isTarget?: boolean
}

interface MatrixStreak {
  id: number
  x: number
  chars: { char: string; y: number; opacity: number }[]
  speed: number
}

export default function TerminalBirthday() {
  const [displayText, setDisplayText] = useState("")
  const [showCursor, setShowCursor] = useState(true)
  const [animationStarted, setAnimationStarted] = useState(false)
  const [matrixChars, setMatrixChars] = useState<MatrixChar[]>([])
  const [matrixStreaks, setMatrixStreaks] = useState<MatrixStreak[]>([])
  const [showStartButton, setShowStartButton] = useState(true)
  const [messageFormed, setMessageFormed] = useState(false)
  const [isShuttingDown, setIsShuttingDown] = useState(false)
  const [shutdownText, setShutdownText] = useState("")
  const animationRef = useRef<number>()
  const lastUpdateRef = useRef<number>(0)
  const streakAnimationRef = useRef<number>()

  const terminalText =
    "$ BIOS v2.4.1 - Birthday Matrix Corporation\n$ POST: Memory test... OK\n$ Loading kernel modules...\n$ [OK] birthday_protocol.ko loaded\n$ [OK] celebration.dll initialized\n$ [OK] neo_cake_driver mounted\n$ Starting birthday matrix services...\n$ reality.exe exited\n$ Entering the Matrix...\n\n"

  const getTargetPositions = useCallback(() => {
    const positions: { x: number; y: number; char: string }[] = []
    const isMobile = window.innerWidth < 768
    const messageWidth = BIRTHDAY_MESSAGE.length * (isMobile ? 16 : 24)
    const startX = (window.innerWidth - messageWidth) / 2
    const startY = window.innerHeight / 2
    const charWidth = isMobile ? 16 : 24

    for (let i = 0; i < BIRTHDAY_MESSAGE.length; i++) {
      if (BIRTHDAY_MESSAGE[i] !== " ") {
        positions.push({
          x: startX + i * charWidth,
          y: startY,
          char: BIRTHDAY_MESSAGE[i],
        })
      }
    }
    return positions
  }, [])

  useEffect(() => {
    const columns: MatrixChar[] = []
    const isMobile = window.innerWidth < 768
    const columnWidth = isMobile ? 15 : 20
    const columnCount = Math.floor(window.innerWidth / columnWidth)

    for (let i = 0; i < columnCount; i++) {
      columns.push({
        char: MATRIX_CHARS[Math.floor(Math.random() * MATRIX_CHARS.length)],
        x: i * columnWidth,
        y: -20,
        opacity: 1,
        settled: false,
      })
    }

    setMatrixChars(columns)
  }, [])

  useEffect(() => {
    if (!animationStarted) return

    let index = 0
    const typeInterval = setInterval(() => {
      if (index < terminalText.length) {
        setDisplayText(terminalText.slice(0, index + 1))
        index++
      } else {
        clearInterval(typeInterval)
        setTimeout(() => {
          startMatrixRain()
        }, 500)
      }
    }, 25)

    return () => clearInterval(typeInterval)
  }, [animationStarted])

  const startMatrixRain = useCallback(() => {
    const targetPositions = getTargetPositions()
    let chars: MatrixChar[] = []
    let lastSpawn = 0
    const spawnedTargets = new Set<number>()
    const isMobile = window.innerWidth < 768
    const spawnDelay = isMobile ? 200 : 150

    const animate = (timestamp: number) => {
      if (timestamp - lastUpdateRef.current < (isMobile ? 40 : 30)) {
        animationRef.current = requestAnimationFrame(animate)
        return
      }
      lastUpdateRef.current = timestamp

      if (timestamp - lastSpawn > spawnDelay) {
        const nextTargetIndex = spawnedTargets.size
        if (nextTargetIndex < targetPositions.length) {
          const targetPos = targetPositions[nextTargetIndex]
          chars.push({
            char: MATRIX_CHARS[Math.floor(Math.random() * MATRIX_CHARS.length)],
            x: targetPos.x,
            y: -20,
            opacity: 1,
            settled: false,
            targetChar: targetPos.char,
            isTarget: true,
          })
          spawnedTargets.add(nextTargetIndex)
          lastSpawn = timestamp
        }
      }

      chars = chars
        .map((char) => {
          if (!char.settled) {
            const newY = char.y + (char.isTarget ? 3 : 5)
            const targetY = window.innerHeight / 2
            if (char.isTarget && newY >= targetY - 10) {
              return {
                ...char,
                y: targetY,
                settled: true,
                opacity: 1,
                char: char.targetChar || char.char,
              }
            } else if (!char.isTarget && newY >= window.innerHeight - 40) {
              return { ...char, y: window.innerHeight - 40, settled: true, opacity: 0.2 }
            }

            return { ...char, y: newY }
          }
          return char
        })
        .filter((char) => char.y < window.innerHeight + 20)

      setMatrixChars([...chars])

      const settledTargets = chars.filter((c) => c.isTarget && c.settled).length
      if (settledTargets >= targetPositions.length && !messageFormed) {
        setMessageFormed(true)
      }

      animationRef.current = requestAnimationFrame(animate)
    }

    animationRef.current = requestAnimationFrame(animate)
  }, [getTargetPositions, messageFormed])

  const initializeMatrixStreaks = useCallback(() => {
    const streaks: MatrixStreak[] = []
    const isMobile = window.innerWidth < 768
    const streakCount = isMobile ? 25 : 80
    const columnWidth = isMobile ? 20 : 25

    for (let i = 0; i < streakCount; i++) {
      const streak: MatrixStreak = {
        id: i,
        x: ((i * columnWidth) % window.innerWidth) + Math.random() * 10,
        chars: [],
        speed: 1 + Math.random() * 2,
      }

      const charCount = 8 + Math.floor(Math.random() * 5)
      for (let j = 0; j < charCount; j++) {
        streak.chars.push({
          char: MATRIX_CHARS[Math.floor(Math.random() * MATRIX_CHARS.length)],
          y: -j * 20 - Math.random() * 200,
          opacity: Math.max(0.1, 1 - j * 0.15),
        })
      }

      streaks.push(streak)
    }

    setMatrixStreaks(streaks)
  }, [])

  const animateMatrixStreaks = useCallback(() => {
    const animate = () => {
      setMatrixStreaks((prevStreaks) =>
        prevStreaks.map((streak) => ({
          ...streak,
          chars: streak.chars.map((char, index) => {
            let newY = char.y + streak.speed
            let newOpacity = char.opacity

            if (newY > window.innerHeight + 50) {
              newY = -20 - index * 20
              newOpacity = Math.max(0.1, 1 - index * 0.15)
            }

            const newChar =
              Math.random() < 0.02 ? MATRIX_CHARS[Math.floor(Math.random() * MATRIX_CHARS.length)] : char.char

            return {
              char: newChar,
              y: newY,
              opacity: newOpacity,
            }
          }),
        })),
      )

      streakAnimationRef.current = requestAnimationFrame(animate)
    }

    streakAnimationRef.current = requestAnimationFrame(animate)
  }, [])

  useEffect(() => {
    if (animationStarted) {
      initializeMatrixStreaks()
      animateMatrixStreaks()
    }

    return () => {
      if (streakAnimationRef.current) {
        cancelAnimationFrame(streakAnimationRef.current)
      }
    }
  }, [animationStarted, initializeMatrixStreaks, animateMatrixStreaks])

  const startAnimation = () => {
    setShowStartButton(false)
    setAnimationStarted(true)
    setDisplayText("")
    setMessageFormed(false)
    setMatrixChars([])
    setMatrixStreaks([])
  }

  const resetAnimation = () => {
    if (animationRef.current) {
      cancelAnimationFrame(animationRef.current)
    }
    if (streakAnimationRef.current) {
      cancelAnimationFrame(streakAnimationRef.current)
    }
    setShowStartButton(true)
    setAnimationStarted(false)
    setDisplayText("")
    setMatrixChars([])
    setMatrixStreaks([])
    setMessageFormed(false)
  }

  const shutdownSequence = () => {
    setIsShuttingDown(true)
    const shutdownMessages = [
      "^C\n",
      "$ Terminating birthday protocol...\n",
      "$ [OK] celebration.dll unloaded\n",
      "$ [OK] neo_cake_driver unmounted\n",
      "$ [OK] birthday_protocol.ko removed\n",
      "$ Stopping matrix services...\n",
      "$ Exiting the Matrix...\n",
      "$ reality.exe restarting...\n",
      "$ System halt.\n",
    ]

    let index = 0
    const shutdownInterval = setInterval(() => {
      if (index < shutdownMessages.length) {
        setShutdownText((prev) => prev + shutdownMessages[index])
        index++
      } else {
        clearInterval(shutdownInterval)
        setTimeout(() => {
          window.location.reload()
        }, 500)
      }
    }, 150)
  }

  useEffect(() => {
    return () => {
      if (animationRef.current) {
        cancelAnimationFrame(animationRef.current)
      }
      if (streakAnimationRef.current) {
        cancelAnimationFrame(streakAnimationRef.current)
      }
    }
  }, [])

  useEffect(() => {
    const handleKeyDown = (event: KeyboardEvent) => {
      if (event.ctrlKey && event.key === "c" && messageFormed && !isShuttingDown) {
        shutdownSequence()
      }
    }

    if (messageFormed) {
      window.addEventListener("keydown", handleKeyDown)
    }

    return () => {
      window.removeEventListener("keydown", handleKeyDown)
    }
  }, [messageFormed, isShuttingDown])

  return (
    <div className="fixed inset-0 bg-black text-green-400 overflow-hidden font-mono border-2 border-green-600 select-none">
      <div className="bg-green-900/50 px-2 sm:px-3 py-1 text-xs sm:text-sm text-green-300 border-b border-green-600 flex items-center justify-between shadow-lg shadow-green-400/20">
        <span className="font-bold text-xs sm:text-sm truncate">neo@matrix:~/birthday_protocol$</span>
        <div className="flex gap-1 sm:gap-2 flex-shrink-0">
          <div className="w-2 h-2 sm:w-3 sm:h-3 bg-red-500 rounded-full shadow-sm"></div>
          <div className="w-2 h-2 sm:w-3 sm:h-3 bg-yellow-500 rounded-full shadow-sm"></div>
          <div className="w-2 h-2 sm:w-3 sm:h-3 bg-green-500 rounded-full shadow-sm animate-pulse"></div>
        </div>
      </div>

      {animationStarted && (
        <div className="absolute inset-0 top-6 sm:top-8 blur-[1px] opacity-25">
          {matrixStreaks.map((streak) =>
            streak.chars.map((char, charIndex) => (
              <div
                key={`${streak.id}-${charIndex}`}
                className="absolute font-mono pointer-events-none text-green-400"
                style={{
                  left: `${streak.x}px`,
                  top: `${char.y}px`,
                  opacity: char.opacity,
                  fontSize: window.innerWidth < 768 ? "10px" : "12px",
                  textShadow: "0 0 4px #00ff00",
                }}
              >
                {char.char}
              </div>
            )),
          )}
        </div>
      )}

      <div className="absolute inset-0 top-6 sm:top-8 z-10">
        {matrixChars
          .filter((char) => char.isTarget)
          .map((char, index) => (
            <div
              key={index}
              className="absolute font-mono pointer-events-none transition-all duration-1100"
              style={{
                left: `${char.x}px`,
                top: `${char.y}px`,
                opacity: char.opacity,
                color: char.settled ? "#00ff00" : "#00ff00",
                letterSpacing: 3,
                textShadow: char.settled ? "0 0 15px #00ff00, 0 0 25px #00ff00" : "0 0 8px #00ff00",
                fontSize: char.settled
                  ? window.innerWidth < 768
                    ? "36px"
                    : "48px"
                  : window.innerWidth < 768
                    ? "14px"
                    : "18px",
                fontWeight: char.settled ? "bold" : "normal",
              }}
            >
              {char.char}
            </div>
          ))}
      </div>

      {showStartButton && (
        <div className="absolute inset-0 backdrop-blur-sm bg-black/50 flex items-center justify-center z-20 p-4">
          <div className="text-center">
            <div className="mb-6 sm:mb-8 text-green-300 text-lg sm:text-xl animate-pulse font-bold tracking-wider px-4">
              ◆ BOOT THE MATRIX ◆
            </div>
            <Button
              onClick={startAnimation}
              className="bg-green-600 hover:bg-green-500 text-black font-mono text-base sm:text-lg px-6 sm:px-8 py-3 sm:py-4 border-2 border-green-400 shadow-lg shadow-green-400/50 transition-all duration-200 hover:shadow-green-400/70 hover:scale-105 touch-manipulation"
            >
              ▶ JACK IN
            </Button>
          </div>
        </div>
      )}

      {animationStarted && (
        <div className="absolute inset-0 top-6 sm:top-8 z-15 p-2 sm:p-4">
          <div className="text-xs sm:text-sm min-h-[150px] sm:min-h-[200px] relative">
            <pre className="whitespace-pre-wrap text-green-400 leading-tight sm:leading-normal">
              {displayText}
              {showCursor && <span className="animate-pulse">█</span>}
            </pre>
          </div>

          {messageFormed && !isShuttingDown && (
            <div className="absolute bottom-4 sm:bottom-8 left-2 sm:left-4 right-2 sm:right-auto">
              <div className="text-green-300 font-mono text-xs sm:text-sm mb-2 font-bold animate-pulse">
                ✦ WISHING PROTOCOL DONE ✦
              </div>
              <div className="text-green-400 font-mono text-xs sm:text-sm animate-pulse bg-green-900/20 p-2 rounded border border-green-600/50">
                <div className="flex flex-col sm:flex-row sm:items-center gap-2">
                  <span className="hidden sm:inline">Press Ctrl + C to exit terminal or </span>
                  <button
                    onClick={shutdownSequence}
                    className="text-green-400 underline hover:text-green-300 cursor-pointer transition-colors duration-200 hover:bg-green-900/30 px-2 py-1 rounded touch-manipulation text-left sm:text-center"
                  >
                    <span className="sm:hidden">tap here to exit</span>
                    <span className="hidden sm:inline">click here</span>
                  </button>
                </div>
              </div>
            </div>
          )}

          {isShuttingDown && (
            <div className="absolute bottom-4 sm:bottom-8 left-2 sm:left-4 right-2 sm:right-4">
              <pre className="whitespace-pre-wrap text-green-400 leading-tight sm:leading-normal bg-black/80 p-2 rounded border border-green-600/50 text-xs sm:text-sm">
                {shutdownText}
              </pre>
            </div>
          )}
        </div>
      )}
    </div>
  )
}

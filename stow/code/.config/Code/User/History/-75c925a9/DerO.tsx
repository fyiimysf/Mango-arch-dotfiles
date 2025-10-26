export default function Home() {

  return (
    <div className="justify-around flex-col items-stretch flex w-screen h-screen">

      {/* Header */}

      <div className="fixed size-full bg-gradient-to-br from-slate-900 via-orange-950 to-rose-900">
        <header className="flex w-full pt-5">
          <div className="container mx-auto px-4 text-center font-serif">
            <h1 className="text-4xl sm:text-6xl text-primary mb-4 text-balance font-light">Untukmu</h1>
            <p className="text-lg sm:text-xl text-muted-foreground max-w-2xl mx-auto text-pretty">
              Istriku manis
            </p>
          </div>
        </header>

        <main className="size-[92%] sm:size-108 mx-auto pt-20 sm:pt-0 " >
          <div className="relative group">
            {/* Gradient background behind video */}

            {/* Video container */}
            <div className="relative bg-card rounded-xl shadow-2xl overflow-hidden border border-primary/30">
              <iframe
                className="aspect-square"
                src="https://rumble.com/embed/v6wmnpq/?autoPlay=0"
                // src="https://drive.google.com/file/d/1fRmbNlmEsJKzqleAuC-WYOkG8wLpIgbW/preview"
                // src="https://d-s.io/e/gxix6d1gynmx"
                allowFullScreen
                seamless
                // sandbox="allow-same-origin allow-scripts" 
                title="untuk istriku"
              />
              


              {/* <iframe
                className="size-54 sm:size-108"
                allowFullScreen={true}
                seamless
                title="untuk istriku"
                /> */}
            </div>
          </div>
        </main>
                <div className="absolute -inset-4 bg-gradient-to-r from-amber-600 via-orange-600 to-rose-600 rounded-2xl blur-xl opacity-20 group-hover:opacity-50 transition-opacity duration-500"></div>

        {/* Footer */}
        <footer className="flex w-full pb-5">
          <div className="container mx-auto px-4 text-center">
            <p className="text-muted-foreground text-sm font-mono">Rendered with love</p>
          </div>
        </footer>
      </div>
    </div>
  )
}

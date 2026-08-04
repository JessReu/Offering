// template.typ

#let project(
  title: "",
  offer_number: "",
  date: "",
  customer_name: "",
  customer_company: "",
  customer_address: "",
  commercial_contact_name: "Daniel Bisogno",
  commercial_contact_department: "BCI/ADM",
  commercial_contact_phone: "+49 (172) 5787450",
  commercial_contact_email: "Order.Manufacturing-Co-Intelligence@bosch.com",
  technical_contact_name: "Denis Court",
  technical_contact_department: "BCI/PAS-EAP",
  technical_contact_phone: "+49 (711) 811-18227",
  technical_contact_email: "Denis.Court@de.bosch.com",
  items: (),
  body,
) = {
  // Set document metadata & typography (with web-safe, universal fallbacks to eliminate warnings)
  set document(author: "Robert Bosch Manufacturing Solutions GmbH", title: title)
  set text(font: "Arial", lang: "de", size: 10.5pt)

  // Configure headings (using 'above' and 'below' for spacing to fix the compiler error)
  set heading(numbering: "1.1")
  show heading: set text(fill: rgb("#005691"), weight: "bold")
  show heading: it => block(above: 1.5em, below: 0.8em, it)

  // Global Page Setup (Margins, Headers, Footers)
  set page(
    margin: (x: 2.5cm, top: 3.2cm, bottom: 3.5cm),
    header: context {
      let current_page = counter(page).get().first()
      let total_pages = counter(page).final().first()

      // Get the active chapter heading before this page
      let active_headings = query(selector(heading.where(level: 1)).before(here()))
      let active_heading = if active_headings.len() > 0 {
        active_headings.last().body
      } else {
        []
      }

      if current_page > 1 [
        #grid(
          columns: (1fr, auto),
          align(left)[
            #text(size: 8pt, fill: luma(120), weight: "medium")[
              #active_heading
            ]
          ],
          align(right)[
            #text(size: 8pt, fill: luma(120))[
              Robert Bosch Manufacturing Solutions GmbH | BCI \
              Seite #current_page von #total_pages \
              Angebot #offer_number
            ]
          ],
        )
        #v(0.4em)
        #line(length: 100%, stroke: 0.5pt + luma(200))
      ]
    },
    footer: context {
      let current_page = counter(page).get().first()

      if current_page > 1 [
        #align(center)[
          #text(7.5pt, fill: luma(120))[
            #line(length: 100%, stroke: 0.5pt + luma(200))
            #v(0.5em)
            Robert Bosch Manufacturing Solutions GmbH | Bosch Connected Industry \
            Wernerstr. 51, 70469 Stuttgart, GERMANY | Bestellannahme: #link("mailto:" + commercial_contact_email) \
            USt-IdNr. DE 306 681 183 | Sitz: Stuttgart | Handelsregister: HRB 757070 \
            Geschäftsführung: Günter Krenz, Dierk Göckel, Norbert Jung, Aemen Bouafif
          ]
        ]
      ]
    },
  )

  // ==========================================
  // 1. COVER PAGE
  // ==========================================
  align(center + horizon)[
    #rect(stroke: 1.5pt + rgb("#005691"), inset: 25pt, radius: 4pt)[
      #text(32pt, weight: "bold", fill: rgb("#005691"))[ANGEBOT] \
      #v(1em)
      #text(16pt, weight: "medium", fill: luma(80))[Projekt: #title] \
      #v(0.5em)
      #text(14pt, fill: luma(100))[Angebotsnummer: #offer_number] \
      #v(0.5em)
      #text(12pt, fill: luma(100))[Datum: #date]
    ]
  ]
  pagebreak()

  // ==========================================
  // 2. CONTACT INFORMATION PAGE
  // ==========================================
  v(1cm)
  grid(
    columns: (1fr, 1.2fr),
    gutter: 20pt,
    [
      #block(
        stroke: 0.5pt + luma(180),
        inset: 15pt,
        radius: 4pt,
        width: 100%,
        fill: luma(250),
        [
          #text(9pt, fill: rgb("#005691"), weight: "bold")[EMPFÄNGER] \
          #v(0.6em)
          #strong(customer_company) \
          #customer_name \
          #customer_address
        ],
      )
    ],
    [
      #block(
        stroke: 0.5pt + luma(180),
        inset: 15pt,
        radius: 4pt,
        width: 100%,
        fill: luma(250),
        [
          #text(9pt, fill: rgb("#005691"), weight: "bold")[ANGEBOTSDETAILS] \
          #v(0.6em)
          #grid(
            columns: (auto, 1fr),
            row-gutter: 6pt,
            column-gutter: 10pt,
            [Angebots-Nr:], [#strong(offer_number)],
            [Datum:], [#date],
          )
          #v(0.8em)
          #line(length: 100%, stroke: 0.5pt + luma(200))
          #v(0.5em)
          #text(8.5pt)[
            #strong("Kaufmännischer Ansprechpartner:") \
            #commercial_contact_name (#commercial_contact_department) \
            Tel: #commercial_contact_phone \
            E-Mail: #link("mailto:" + commercial_contact_email) \
            \
            #strong("Technische Kundenbetreuung:") \
            #technical_contact_name (#technical_contact_department) \
            Tel: #technical_contact_phone \
            E-Mail: #link("mailto:" + technical_contact_email)
          ]
        ],
      )
    ],
  )
  v(2em)

  // ==========================================
  // 3. TABLE OF CONTENTS
  // ==========================================
  outline(
    title: "Inhaltsverzeichnis",
    depth: 2,
    indent: 1.5em,
  )
  pagebreak()

  // ==========================================
  // 4. DOCUMENT BODY (STANDARD TEMPLATE CONTENT)
  // ==========================================
  [
    Guten Tag #customer_name,

    #v(1em)
    vielen Dank für das angenehme Gespräch und Ihr Interesse an unseren Softwarelösungen und Dienstleistungen. Auf dieser Basis bieten wir Ihnen gerne den *Bosch Semantic Stack* zu den folgenden Konditionen an:

    = Leistungen und Preise

    // Daten aus JSON laden, Preise aus Menge x Einzelpreis berechnen
    #let eur(value) = str(value) + ",00"
    #let line-items = json("line_items.json").line_items

    #let positionen = line-items.map(item => (
      id: item.at("ID"),
      gruppe: item.at("Gruppe"),
      bezeichnung: item.at("Bezeichnung"),
      einheit: item.at("Einheit"),
      einzelpreis: item.at("Einzelpreis"),
      beschreibung: item.at("Beschreibung"),
    ))

    == Übersicht
    #table(
      columns: (auto, 3fr, auto, auto, auto, auto),
      stroke: 0.5pt + luma(180),
      fill: (x, y) => if y == 0 { rgb("#005691").lighten(90%) } else if y == 4 { luma(240) } else { none },
      align: (center, left, center, center, right, right),
      inset: 7pt,
      table.header([*Pos.*], [*Bezeichnung*], [*Menge*], [*Einheit*], [*Einzelpreis EUR*], [*Preis EUR*]),
      // for item in items [
      //   [#item.pos], [#item.bezeichnung], [#str(item.menge)], [#item.einheit], [#eur(item.einzelpreis)], [#eur(item.einzelpreis * item.menge)]
      // ],
      // table.cell(colspan: 5, align: right)[*Endsumme zzgl. MwSt.*], [*#eur(endsumme)*],
    )

    == Details
    #table(
      columns: (auto, 3fr, auto, auto, auto, auto),
      stroke: 0.5pt + luma(200),
      fill: (x, y) => if y == 0 { rgb("#005691").lighten(90%) } else if y == 9 { luma(240) } else { none },
      align: (center, left, center, center, right, right),
      inset: 6pt,
      table.header([*Pos.*], [*Bezeichnung*], [*Menge*], [*Einheit*], [*Einzelpreis EUR*], [*Preis EUR*]),
      // for group in items.groups [
      //   let group_items = positionen.filter(p => p.gruppe == group.ID)
      //   let group_summe = summe-gruppe(group.ID)
      //   [*#group.ID*], [*#group.Bezeichnung*], "", "", "", [*#eur(group_summe)*]
      //   for item in group_items [
      //     [#item.pos], [#item.bezeichnung], [#str(item.menge)], [#item.einheit], [#eur(item.einzelpreis)], [#eur(item.preis)]
      //     "", table.cell(colspan: 5)[#emph(if item.beschreibung != null { item.beschreibung } else { "_Keine zusätzliche Beschreibung._" })]
      //   ]
      // ],
      // table.cell(colspan: 5, align: right)[*Endsumme zzgl. MwSt.*], [*#eur(endsumme)*],
    )

    #pagebreak()

    == Line Items

    #let full-data = json("line_items_full.json")
    #let full-items = full-data.at("line_items")
    #let full-groups = full-data.at("groups")
    #let endsumme = full-items.fold(0.0, (acc, item) => acc + item.at("Einzelpreis") * item.at("Menge"))

    #table(
      columns: (auto, 3fr, auto, auto, auto, auto),
      stroke: 0.5pt + luma(180),
      fill: (x, y) => if y == 0 { rgb("#005691").lighten(90%) } else { none },
      align: (center, left, center, center, right, right),
      inset: 7pt,
      table.header([*Pos.*], [*Bezeichnung*], [*Menge*], [*Einheit*], [*Einzelpreis EUR*], [*Preis EUR*]),
      ..full-groups.map(group => {
        let gid = group.at("ID")
        let gpos = group.at("Pos.")
        let group-items = full-items.filter(item => item.at("Gruppe") == gid)
        let group-sum = group-items.fold(0.0, (acc, item) => acc + item.at("Einzelpreis") * item.at("Menge"))
        let cells = (
          table.cell(colspan: 5, fill: rgb("#005691").lighten(80%))[*#gpos — #group.at("Bezeichnung")*],
          table.cell(fill: rgb("#005691").lighten(80%))[*#eur(int(group-sum))*],
        )
        cells + group-items.enumerate().map(pair => {
          let i = pair.first()
          let item = pair.last()
          let pos = gpos + "." + str(i + 1)
          let preis = item.at("Einzelpreis") * item.at("Menge")
          (
            [#pos],
            [#item.at("Bezeichnung")\ #text(size: 9pt, style: "italic")[#item.at("Beschreibung")]],
            [#str(item.at("Menge"))],
            [#item.at("Einheit")],
            [#eur(int(item.at("Einzelpreis")))],
            [#eur(int(preis))],
          )
        }).flatten()
      }).flatten(),
      table.cell(colspan: 5, align: right)[*Endsumme zzgl. MwSt.*],
      [*#eur(int(endsumme))*],
    )

    = Vertragsbedingungen

    == Angebotsgültigkeit
    Die Angebotsgültigkeit beträgt *3 Monate* ab Erstellungsdatum (#date).

    == Liefertermin
    Geplanter Liefertermin ist der *31.12.2026*. Geplanter Umsetzungszeitraum ist der *01.09.2026 - 31.12.2026*.

    == Bereitstellungstermin
    Geplanter Bereitstellungstermin für die Software-as-a-Service Komponenten ist der *01.09.2026*.

    == Personentage (PT)
    Ein Personentag entspricht *8 Stunden*. Stunden über- oder unterhalb dieser Grenze werden anteilig berechnet.

    = Ergänzende Vertragsbedingungen
    - Für die entgeltliche, zeitlich befristete Nutzung von Software gelten die *SaaS-Nutzungsbedingungen vom 11.09.2025* der Robert Bosch Manufacturing Solutions GmbH.
    - Für die Erbringung der Werk- oder Dienstleistungen gelten die *Bedingungen für Werk- und Dienstleistungen vom 24.02.2026* der Robert Bosch Manufacturing Solutions GmbH.
    - Für die vertraglich geregelten Dienste gilt die *Service-Level-Vereinbarung (SLA, Service Level Agreement) vom 19.02.2026* der Robert Bosch Manufacturing Solutions GmbH.

    = Signatur
    Wir hoffen, dass dieses Angebot Ihren Erwartungen entspricht, und würden uns freuen, wenn Sie sich dazu entscheiden, dieses Projekt mit uns zu realisieren. Für weitere Informationen und zur Beantwortung Ihrer Fragen stehen wir Ihnen gerne zur Verfügung.

    Mit freundlichen Grüßen,
    #v(2.5em)

    #grid(
      columns: (1fr, 1fr),
      gutter: 40pt,
      [
        #line(length: 85%, stroke: 0.5pt + luma(100)) \
        #v(-0.5em)
        #text(8pt, fill: luma(100))[Ort, Datum, Unterschrift Robert Bosch GmbH]
      ],
      [
        #line(length: 85%, stroke: 0.5pt + luma(100)) \
        #v(-0.5em)
        #text(8pt, fill: luma(100))[Ort, Datum, Unterschrift Kunde]
      ],
    )

    // Render any extra body text written below the `#show` statement in the offer file
    #body
  ]
}

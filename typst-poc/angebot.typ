#import "template.typ": project

#let line_items = json("line_items.json");

#show: project.with(
  title: "Bosch Semantic Stack Software-as-a-Service",
  offer_number: "123.292123456",
  date: "03.08.2026",
  customer_name: "Herr Müller",
  customer_company: "Musterfirma GmbH",
  customer_address: "Musterstraße 12, 12345 Musterstadt",
  items: (
    battery-pass-xs: 1,
    semantic-stack-consulting: 42,
  )
)

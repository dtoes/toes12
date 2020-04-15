variable "prefix" {
  description = "Naamgeving voor de verschillende resources die aangemaakt worden"
  default = "db-pgsql-toes"
}

variable "location" {
  description = "Welke Azure region moet er gebruikt worden"
  default = "eastus"
}

variable "omgeving" {
  description = "Soort omgeving zoals test,dev of productie"
  default = "database"
}

variable "gebruikersnaam" {
  description = "Soort omgeving zoals test,dev of productie"
  default = "daantoes"
}

variable "wachtwoord" {
  description = "Soort omgeving zoals test,dev of productie"
  default = "Welkom01!"
}
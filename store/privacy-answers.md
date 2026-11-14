# Odpovědi do App Privacy a Data safety

Připravené odpovědi pro build s anonymními statistikami (`docs/telemetry.md`,
plán `DevConventions/Prompts/04-PLAN-analytika.md`). **Vyplnit až po
zveřejnění nového `docs/privacy.html`** a před odesláním prvního buildu s
klíčem `TELEMETRY_KEY`. Pořadí: politika → formuláře → klíč → vydání.

Odpovídají `app/ios/Runner/PrivacyInfo.xcprivacy`. Co je dnes v App Store
Connect a Play Console vyplněné, v repu není. Nejdřív porovnat a ponechat
vše ostatní, co tam už je.

Privacy Policy URL: `https://lioilsources.github.io/Translator/privacy.html`
(GitHub Pages z `main /docs`, je potřeba zapnout).

## Statistiky (hotovo)

### App Store Connect → App Privacy

**Do you or your third-party partners collect data from this app?** Yes.

| Kategorie → typ | Propojeno s uživatelem? | Ke sledování? | Účel |
|---|---|---|---|
| Usage Data → **Product Interaction** | No | No | Analytics |
| Diagnostics → **Performance Data** | No | No | Analytics |
| Location → **Coarse Location** | No | No | Analytics |

- *Product Interaction*: spuštění, obrazovky a sekundy na nich, začátek a
  konec rozhovoru (jazykový pár, sekundy, výsledek), první použití funkcí,
  druhy chyb.
- *Performance Data*: doba spojení se serverem v milisekundách
  (`translate_ready`).
- *Coarse Location*: vlastní příjemce vývojáře odvodí zemi z IP, uloží jen
  zemi, IP neukládá. Kdyby se země na příjemci vypnula, řádek odškrtnout a
  odebrat `NSPrivacyCollectedDataTypeCoarseLocation` z manifestu.

Propojeno: No (žádný účet ani identifikátor ve statistikách, ID relace je
náhodné a jen v paměti). Tracking: No (`NSPrivacyTracking` je `false`,
žádná výzva ATT).

### Google Play → Data safety

Statistiky jdou jen na vlastní server vývojáře v EU (Česko), žádná třetí
strana je nedostane: **collected, not shared**.

| Typ dat | Účel | Ephemeral? | Povinné/volitelné |
|---|---|---|---|
| App activity → **App interactions** | Analytics | No | **Optional** (vypínač v Nastavení) |
| App info and performance → **Diagnostics** | Analytics | No | Optional (stejný vypínač) |
| Location → **Approximate location** | Analytics | No | Optional (stejný vypínač) |

- Encrypted in transit: Yes (klient statistik odmítne host bez `https`).
- Deletion: statistiky nenesou identifikátor, záznam nejde dohledat k
  osobě. Vypínač smaže neodeslané záznamy na zařízení, na serveru se
  mažou po 12 měsících.

## Samotný překlad (doplní Olin)

Tohle z kódu appky nejde rozhodnout. Jde o to, co server dělá s daty a kdo
ho provozuje, takže to musí doplnit Olin. Co appka posílá, je jasné
(`docs/privacy.html`, oddíl Translation): audio promluv, jazyky, režim,
volba hlasů, ID zařízení a token, případně zvací kód; na přání 30s nahrávka
vlastního hlasu se jménem.

Otevřené otázky:

- **Audio Data / Voice or sound recordings**: knihovna hlasů ukládá nahrávku
  na serveru do smazání → nejspíš *collected*, účel App Functionality,
  propojeno se zařízením. Audio hovorů se podle invariantu v `CLAUDE.md`
  neukládá ani neloguje. Pokud se zpracuje jen v reálném čase, podle Applu
  to není „collection“ a na Play to je *ephemeral*. Ověřit to na
  provozovaných serverech.
- **Identifiers → Device ID**: náhodné ID zařízení a token od serveru.
  Server nemá databázi, ID je v podepsaném tokenu a u hlasů. Rozhodnout, zda
  a jak deklarovat (App Functionality, propojeno).
- **Kdo zpracovává**: kde běží backendy L40S a SPARK a kdo je provozuje,
  Cloudflare tunel před nimi, LLM, ASR a TTS služby. Doplnit do politiky,
  pokud jde o třetí stranu.
- **Uchování na serveru**: logy (`session started` loguje jazyky, režim a
  zařízení), denní počitadla minut a IP v paměti kvůli limitu registrací.

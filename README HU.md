# Automatizált szállítószalagos válogatórendszer

### CODESYS 3.5 + Factory I/O | Structured Text | OPC UA

Ez a projekt egy ipari automatizálási szimuláció, amely egy olyan automatizált szállítószalag-rendszert mutat be, amely képes a dobozok magasságának felismerésére, válogatására és darabszámuk nyilvántartására.

A rendszer a PLC-programozáshoz **CODESYS 3.5** környezetet, a háromdimenziós ipari folyamat szimulációjához pedig **Factory I/O** szoftvert használ. A két környezet közötti kommunikáció **OPC UA** protokollon keresztül valósul meg, lehetővé téve, hogy a PLC valós időben fogadja az érzékelők jeleit, és vezérelje a szimulált gépelemeket.

A projekt egy automatizált válogatási folyamat fejlesztését mutatja be, a dobozok kezdeti érzékelésétől és osztályozásától kezdve a szállítószalagok irányításán és a forgóasztal működtetésén át egészen a termelési darabszám nyomon követéséig.

---

## Tartalomjegyzék

- [A projekt áttekintése](#a-projekt-áttekintése)
- [Bemutatóvideók](#bemutatóvideók)
- [A rendszer felépítése](#a-rendszer-felépítése)
- [Felhasznált technológiák](#felhasznált-technológiák)
- [Rendszerarchitektúra](#rendszerarchitektúra)
- [A válogatási folyamat működése](#a-válogatási-folyamat-működése)
- [PLC-programozás](#plc-programozás)
- [Kezelőpanel](#kezelőpanel)
- [OPC UA kommunikáció és konfiguráció](#opc-ua-kommunikáció-és-konfiguráció)
- [Érzékelők és beavatkozók](#érzékelők-és-beavatkozók)
- [Biztonsági funkciók és üzemmódok](#biztonsági-funkciók-és-üzemmódok)
- [Termelési darabszámláló](#termelési-darabszámláló)
- [Fejlesztési kihívások és megoldások](#fejlesztési-kihívások-és-megoldások)
- [Továbbfejlesztési lehetőségek](#továbbfejlesztési-lehetőségek)
- [Összegzés](#összegzés)

---

## A projekt áttekintése

A projekt célja egy olyan automatizált szállítószalagos válogatórendszer megtervezése és programozása volt, amely képes megkülönböztetni a magas és alacsony dobozokat, majd azokat két külön szállítószalag-ágra irányítani.

A rendszer magasságérzékelő szenzorok segítségével osztályozza az érkező dobozokat. Az érzékelt magasság alapján a PLC vezérli a forgóasztalos válogatómechanizmust, amely a megfelelő szállítószalag felé irányítja a dobozokat.

Az automatizálási folyamat vezérlését a CODESYS környezetben futó Structured Text (ST) program végzi, míg a Factory I/O biztosítja a szimulált ipari környezetet, beleértve a szállítószalagokat, érzékelőket, beavatkozókat, dobozokat és kezelőszerveket.

A projekt teljes egészében szimulációs környezetben készült, fizikai PLC vagy ipari hardver használata nélkül.

### Főbb funkciók

- Automatikus dobozkibocsátás és szállítás.
- Magas és alacsony dobozok érzékelése és osztályozása.
- Automatikus válogatás két külön szállítószalag-ágra.
- Forgóasztalos válogatómechanizmus működtetése.
- Szenzorvezérelt folyamatirányítás.
- A forgóasztal automatikus visszaállása.
- Kézi és automatikus üzemmód.
- Start, Stop és Vészleállítás funkció.
- Visszaállítási (Reset) funkció.
- A termelési darabszám megjelenítése a Factory I/O felületén.
- Valós idejű kommunikáció a CODESYS és a Factory I/O között OPC UA protokollon keresztül.

---

## Bemutatóvideók

Az alábbi videók a rendszer működését mutatják be a Factory I/O és a CODESYS egyidejű használatával.

**PLC-program működésének bemutatása:**

https://www.youtube.com/watch?v=FjgqUa7RV2A

**Factory I/O szimuláció bemutatása:**

https://www.youtube.com/watch?v=iOEDZyAuSeM

A bemutatók szemléltetik a szimulált gépelemek és a PLC-program közötti együttműködést, beleértve a dobozok érzékelését, osztályozását, válogatását, a szállítószalagok vezérlését és a termelési darabszám számlálását.

---

## A rendszer felépítése

A szimuláció a Factory I/O **Sorting by Height (Advanced)** nevű jelenetére épül.

A rendszer egy bemeneti szakaszból, egy magasságérzékelő területből, egy forgóasztalos válogatóegységből, valamint két kimeneti szállítószalag-útvonalból áll.

### Factory I/O – A teljes rendszer áttekintése

<img src="./screenshots/FactoryIO%20Overview.png" width="600">

### Kezelőpanel

<img src="./screenshots/Control%20Panel%20FactoryIO.png" width="600">

A kezelőpanel biztosítja a rendszer indításához és leállításához, az üzemmód kiválasztásához, valamint a vészleállítási reteszelés visszaállításához szükséges kezelőszerveket.

### Válogatómechanizmus

**Forgóasztal**

<img src="./screenshots/FactoryIO%20Turntable.png" width="600">

A forgóasztal feladata a doboz megfelelő pozícióba állítása a kiválasztott válogatási művelethez. A vezérlőjel kikapcsolásakor a mechanizmus automatikusan visszatér a kiindulási helyzetébe.

**Bal oldali szállítószalag és dobozkimenet**

<img src="./screenshots/FactoryIO%20Box%20on%20the%20left.png" width="600">

A bal oldali szállítószalag a magasnak minősített dobozokat továbbítja.

**Eltávolító mechanizmus**

<img src="./screenshots/FactoryIO%20Remover.png" width="600">

Az eltávolító mechanizmus segíti a dobozok továbbítását a megfelelő válogatási útvonalon.

---

## Felhasznált technológiák

| Technológia | Felhasználás |
|---|---|
| CODESYS 3.5 (SP22) | PLC-programozás és programfuttatás |
| Structured Text (ST) | Automatizálási vezérlőprogram |
| Factory I/O | Ipari folyamat szimulációja |
| OPC UA | Kommunikáció a CODESYS és a Factory I/O között |
| CODESYS Control Win V3 x64 | SoftPLC futtatókörnyezet |
| GitHub | Forráskód és projekt dokumentációja |

---

## Rendszerarchitektúra

A projekt PLC-vezérelt rendszerarchitektúrát alkalmaz.

A Factory I/O biztosítja a fizikai folyamat szimulációját, míg a CODESYS feldolgozza az érzékelők jeleit, és meghatározza, hogy mely beavatkozókat kell aktiválni.

A kommunikáció folyamata:

1. A Factory I/O érzékelői észlelik a dobozokat és a gép aktuális állapotát.
2. Az érzékelők jelei OPC UA kapcsolaton keresztül eljutnak a CODESYS környezetbe.
3. A PLC-program feldolgozza a bemeneti jeleket, majd végrehajtja a programozott vezérlési folyamatot.
4. A CODESYS visszaküldi a kimeneti vezérlőjeleket a Factory I/O számára.
5. A Factory I/O működteti a megfelelő szállítószalagokat, a forgóasztalt és a válogatómechanizmusokat.

<img src="./screenshots/FactoryIO%20Driver%20Config.png" width="600">

### OPC UA konfiguráció

<img src="./screenshots/FIO%20Config.png" width="600">

A CODESYS alkalmazás a Symbol Configuration segítségével publikálja a szükséges globális változókat, így a Factory I/O hozzáférhet a PLC bemeneti és kimeneti jeleihez.

A változók külön csoportokba vannak rendezve: kezelői bemenetek, pozícióérzékelők, dobozérzékelő szenzorok, szállítószalag-kimenetek, válogatómechanizmusok és visszajelző lámpák.

---

## A válogatási folyamat működése

Az automatikus válogatási folyamat vezérlése egy lépésekre bontott állapotgéppel történik, amelyet a Structured Text programban egy `CASE` utasítás valósít meg.

Minden lépés a gyártási folyamat egy meghatározott szakaszát képviseli.

### 1. Dobozok kibocsátása és adagolása

Automatikus üzemmódban a gép működésekor az emitter dobozokat bocsát ki, a feeder és az entry szállítószalagok pedig a válogatási terület felé továbbítják azokat.

Amikor egy doboz eléri a forgóasztal előtti belépési érzékelőt, a PLC elindítja a betöltési folyamatot.

### 2. Dobozérzékelés és osztályozás

A rendszer két magasságérzékelő szenzort használ:

- **LowBox:** Az alsó érzékelési szinten áthaladó dobozokat érzékeli.
- **HighBox:** A felső érzékelési szintet elérő dobozokat érzékeli.

Minden doboz aktiválja az alsó érzékelőt, míg a magas dobozok a felső érzékelőt is aktiválják.

A PLC a doboz besorolását a belső `BoxIsHigh` logikai változóban tárolja.

Ennek köszönhetően a vezérlési logika a doboz besorolását a forgóasztalhoz történő továbbítás során is meg tudja őrizni.

### 3. A forgóasztal működése

Amikor a doboz eléri az elülső pozíciót, elindul a forgóasztal válogatási folyamata.

A forgóasztal működtető kimenete megközelítőleg nyolc másodpercig aktív.

Két másodperces késleltetés után a PLC aktiválja a megfelelő válogató kimenetet:

- Magas doboz: `FIO.Load`
- Alacsony doboz: `FIO.Unload`

A forgóasztal vezérlőjelének kikapcsolásakor a Factory I/O automatikusan visszaállítja a mechanizmust a kiindulási helyzetébe.

### 4. Dobozok továbbítása a megfelelő szállítószalagra

A válogató kimenet mindaddig aktív marad, amíg a megfelelő kilépési érzékelő nem érzékeli a dobozt.

| Doboz besorolása | Válogató kimenet | Szállítószalag | Kilépési érzékelő |
|---|---|---|---|
| Magas | Load | Bal oldali | AtLeftExit |
| Alacsony | Unload | Jobb oldali | AtRightExit |

A megfelelő kilépési érzékelő aktiválódásakor a vezérlési folyamat továbblép a következő állapotra.

### 5. A folyamat újraindítása

Miután a doboz elérte a célállomását, a PLC a programozott késleltetés leteltéig vár, majd újraindítja az adagolási folyamatot.

A rendszer előkészíti a következő doboz fogadását, és a válogatási ciklus ismétlődik.

---

## PLC-programozás

A PLC-program az IEC 61131-3 szabvány szerinti Structured Text nyelven, CODESYS 3.5 környezetben készült.

Az automatikus folyamat vezérlése egy lépésekre bontott szekvenciával történik, amelynek állapotát a `FeedStep` nevű egész típusú változó tárolja.

### Fő vezérlési lépések

| Lépés | Művelet |
|---|---|
| 0 | Normál adagolás és dobozérzékelés |
| 10 | Doboz betöltése a forgóasztalra |
| 30 | Forgóasztal mozgatása és válogatási késleltetés |
| 40 | Válogató kimenet fenntartása a megfelelő kilépési érzékelő aktiválásáig |
| 50 | Várakozás az újraindítás előtt |
| 70 | Újraindítási késleltetés és felkészülés a következő ciklusra |

A szekvencia több TON (bekapcsolás-késleltető) időzítőt használ:

| Időzítő | Időtartam | Funkció |
|---|---:|---|
| `tTurnPulse` | 8 másodperc | A forgóasztal működtetésének időzítése |
| `tEntryFeed` | 2 másodperc | A belépő szállítószalag adagolási idejének vezérlése |
| `tSortDelay` | 2 másodperc | A válogató kimenet aktiválásának késleltetése |
| `tReturnDelay` | 2 másodperc | Várakozás a doboz kilépése után |
| `tRestartFeed` | 2 másodperc | Késleltetés a következő adagolási ciklus előtt |

Az időzítők kiszámítható folyamatvezérlést biztosítanak, és megakadályozzák, hogy a működés kizárólag az érzékelők időzítésétől függjön.

### Példa: Magasság szerinti osztályozás

```iecst
IF (FeedStep = 0 OR FeedStep = 10) AND FIO.HighBox THEN
    BoxIsHigh := TRUE;
END_IF
```

A program a `BoxIsHigh` változóban tárolja a magas doboz besorolását, amelyet később a megfelelő válogatási útvonal kiválasztásához használ fel.

### Példa: Válogatási logika

```iecst
IF BoxIsHigh THEN
    FIO.Load := TRUE;

    IF FIO.AtLeftExit THEN
        FeedStep := 50;
    END_IF
ELSE
    FIO.Unload := TRUE;

    IF FIO.AtRightExit THEN
        FeedStep := 50;
    END_IF
END_IF
```

Ez biztosítja, hogy a magas és alacsony dobozok a tárolt besorolásuknak megfelelő szállítószalag-ágra kerüljenek.

---

## Kezelőpanel

A kezelőfelület biztosítja a szimulált gyártórendszer működtetéséhez szükséges fő kezelőszerveket.

| Kezelőszerv | Funkció |
|---|---|
| Start | Elindítja a gép működését |
| Stop | Leállítja a gép működését |
| Emergency Stop | Azonnal leállítja a gépet és aktiválja a vészleállítási reteszelést |
| Reset | Feloldja a vészleállítási reteszelést és nullázza a termelési számlálót |
| Auto Mode | Engedélyezi az automatikus válogatást |
| Manual Mode | Engedélyezi a kézi üzemmódot |

A visszajelző lámpák vizuális információt adnak a rendszer állapotáról:

- Zöld jelzőlámpa: A gép működik.
- Piros jelzőlámpa: A gép áll.
- Reset jelzőlámpa: A vészleállítási reteszelés aktív.

---

## OPC UA kommunikáció és konfiguráció

A CODESYS és a Factory I/O közötti kommunikáció OPC UA protokoll segítségével valósul meg.

A PLC változói a CODESYS Symbol Configuration funkcióján keresztül érhetők el, majd ezek hozzá vannak rendelve a Factory I/O megfelelő érzékelőihez és beavatkozóihoz.

A kommunikáció az alábbi jeleket foglalja magában:

- Kezelői vezérlőjelek.
- Pozíció- és dobozérzékelő szenzorok.
- Szállítószalagok vezérlőjelei.
- Forgóasztal- és válogatómechanizmusok vezérlőjelei.
- Visszajelző lámpák.
- Termelési darabszámláló.

Ez a felépítés lehetővé teszi, hogy a PLC-program valós idejű bemeneti és kimeneti jelek segítségével vezérelje a szimulált gépelemeket.

---

## Érzékelők és beavatkozók

### Érzékelők

A projekt több digitális érzékelőt használ a dobozok helyzetének és magasság szerinti besorolásának nyomon követésére.

| Érzékelő | Feladat |
|---|---|
| `AtTurntableEntry` | A forgóasztalhoz érkező doboz érzékelése |
| `AtFront` | A doboz elülső pozíciójának érzékelése |
| `AtLeftExit` | A doboz bal oldali szállítószalag végéhez érkezésének érzékelése |
| `AtRightExit` | A doboz jobb oldali szállítószalag végéhez érkezésének érzékelése |
| `LowBox` | Az alsó magassági szinten lévő dobozok érzékelése |
| `HighBox` | A felső magassági szintet elérő dobozok érzékelése |

### Beavatkozók

| Beavatkozó | Feladat |
|---|---|
| `Emitter1` | Dobozok kibocsátása |
| `FeederConveyor` | Dobozok adagolása a rendszerbe |
| `EntryConveyor` | Dobozok továbbítása a forgóasztal felé |
| `LeftConveyor` | Magas dobozok továbbítása |
| `RightConveyor` | Alacsony dobozok továbbítása |
| `Turn` | A forgóasztal működtetése |
| `Load` | A bal oldali válogatási útvonal kiválasztása |
| `Unload` | A jobb oldali válogatási útvonal kiválasztása |

---

## Biztonsági funkciók és üzemmódok

A PLC-program alapvető szimulált gépvezérlési és biztonsági reteszelési funkciókat tartalmaz.

### Start és Stop

A gép működése öntartó állapotváltozóval történik. A Start gomb megnyomásakor a rendszer elindul, a Stop gomb megnyomásakor pedig leáll.

### Vészleállítás (Emergency Stop)

A PLC folyamatosan figyeli a vészleállító bemenet állapotát.

A vészleállítás aktiválásakor a PLC:

1. Aktiválja a vészleállítási reteszelést.
2. Leállítja a gép működését.
3. Megakadályozza az automatikus folyamat normál folytatását.

A reteszelés mindaddig aktív marad, amíg a vészleállító gombot fel nem engedik, majd a Reset bemenet aktiválásával a reteszelés fel nem oldódik.

### Automatikus és kézi üzemmód

A rendszer két különböző üzemmódot támogat.

**Automatikus üzemmód (Automatic Mode):**

A PLC érzékelő-visszajelzések és időzítők segítségével végrehajtja a teljes válogatási folyamatot.

**Kézi üzemmód (Manual Mode):**

A gép működése közben az emitter, az adagoló szállítószalag és a belépő szállítószalag folyamatosan működtethető.

*Megjegyzés: Ezek szimulált vezérlési funkciók, és nem helyettesítik a tanúsított ipari biztonsági berendezéseket vagy a biztonsági PLC-t.*

---

## Termelési darabszámláló

A termelési számláló a rendszerben az alsó magasságérzékelő által észlelt dobozok számát követi.

A számlálás egy `R_TRIG` felfutó él érzékelő funkcióblokk segítségével történik. Ez biztosítja, hogy egy doboz csak egyszer kerüljön beszámításra akkor is, ha az érzékelő jele több PLC-cikluson keresztül aktív marad.

A belső számláló `DINT` típusú, értéke pedig az alábbi utasítással kerül továbbításra a Factory I/O termelési kijelzőjére:

```iecst
FIO.ProductionCounter := BoxCounter;
```

A Reset gomb megnyomásakor a számláló értéke nullára áll vissza.

---

## Fejlesztési kihívások és megoldások

A fejlesztés során több gyakorlati probléma is felmerült. Ezek megoldása a projekt fontos részét képezte.

### 1. OPC UA kommunikáció

A kezdeti beállítás során szükség volt a CODESYS alkalmazás megfelelő konfigurálására, a szükséges globális változók publikálására, valamint a Factory I/O driver megfelelő beállítására.

**Megoldás:**

Az OPC UA támogatás engedélyezése, a Symbol Configuration beállítása, majd a Factory I/O jeleinek hozzárendelése a megfelelő CODESYS változókhoz.

### 2. Aktív alacsony szintű Stop és Emergency Stop bemenetek

A Stop és Emergency Stop jelek aktív alacsony szintű (active-low) bemenetként működtek.

Ez azt jelentette, hogy a jelek felengedett állapotban TRUE, megnyomott állapotban pedig FALSE értéket adtak.

**Megoldás:**

A PLC-programot a bemenetek fordított logikájához kellett igazítani, így a gombok megnyomását invertált feltételekkel lehetett felismerni.

### 3. Dobozok osztályozása és az érzékelők elhelyezése

Az egyik legfontosabb probléma akkor jelentkezett, amikor egy új doboz elérte a magasságérzékelőket, miközben az előző doboz válogatása még folyamatban volt.

Egy magas doboz idő előtt aktiválhatta a `HighBox` érzékelőt, még mielőtt az előző doboz befejezte volna a válogatási folyamatot. Ez megváltoztathatta az eltárolt besorolást, és egy alacsony doboz hibásan a magas dobozok számára fenntartott szállítószalagra kerülhetett.

**Megoldás:**

Mindkét magasságérzékelő szenzort fizikailag közelebb helyeztem a forgóasztalhoz. Ez biztosította, hogy az egyes dobozok a folyamat megfelelő pontján kerüljenek osztályozásra, és csökkentette az egymást követő dobozok közötti időzítési interferenciát.

Ez a probléma jól szemléltette az ipari automatizálás egyik fontos alapelvét: a megfelelő PLC-programozás mellett az érzékelők fizikai elhelyezkedését és időzítését is figyelembe kell venni.

### 4. A forgóasztal működése

A forgóasztal beavatkozója eltérően viselkedik egy hagyományos motorvezérlő kimenettől. Aktiválásakor elmozdítja a forgóasztalt, kikapcsolásakor pedig a mechanizmus automatikusan visszatér a kiindulási helyzetébe.

**Megoldás:**

A PLC szekvenciáját úgy alakítottam ki, hogy a forgóasztal meghatározott ideig aktív legyen, majd a vezérlőjel kikapcsolásával a Factory I/O automatikusan végrehajtsa a visszaállást.

### 5. Termelési darabszám számlálása

Egy egyszerű logikai feltétel minden PLC-ciklusban növelte volna a számlálót, amíg az érzékelő TRUE állapotban marad.

**Megoldás:**

Az `R_TRIG` funkcióblokkot alkalmaztam, amely kizárólag a jel felfutó élét érzékeli. Ez biztosítja, hogy egy aktiválás csak egyetlen számlálást eredményezzen.

---

## Továbbfejlesztési lehetőségek

A rendszer a későbbiekben több irányban is továbbfejleszthető:

- Külön termelési számláló a magas és alacsony dobozok számára.
- Összesített termelési statisztikák megjelenítése.
- Hibafelismerés és diagnosztikai üzenetek.
- Szállítószalag-elakadás érzékelése.
- Az egyes beavatkozók fejlettebb kézi vezérlése.
- HMI fejlesztése élő folyamatmegjelenítéssel.
- Termelési hatékonyság és ciklusidő figyelése.
- Fejlettebb szekvenciavezérlés több doboz egyidejű feldolgozásához.
- További válogatási kategóriák bevezetése.

---

## Összegzés

A projekt egy teljes szimulált ipari válogatórendszer megvalósítását mutatja be PLC-programozás és Factory I/O segítségével.

A rendszer egyesíti a Structured Text programozást, az OPC UA kommunikációt, a szenzor-visszajelzéseket, a beavatkozók vezérlését, az időzítőket, az állapotgépes folyamatirányítást és az alapvető biztonsági reteszelési funkciókat.

A szükséges válogatási funkciók megvalósítása mellett a projekt gyakorlati tapasztalatot nyújtott a PLC-programok hibakeresésében, az érzékelők működésének megértésében, az időzítési összefüggések kezelésében és a vezérlési logika fizikai folyamat viselkedéséhez történő igazításában.

Az eredmény egy működő automatizált szállítószalagos válogatórendszer-szimuláció, amely képes a magas és alacsony dobozok felismerésére, külön szállítószalagokra irányítására és a termelési darabszám nyomon követésére.

**A projekt a CODESYS 3.5 és a Factory I/O felhasználásával készült, gyakorlati ipari automatizálási és PLC-programozási feladatként.**

# Diànchí xìnxī fǔzhù bǔdīng ## gàishù - jiào xīn de***VirtualSMC.Kext*** yǐjí tā de zǔjiàn***kext***[8 yuè 14 rì zhīhòu] tígōngle xiǎnshì diànchí fǔzhù xìnxī jiēkǒu. Tōngguò dìngzhì SSDT bǔdīng zài qūdòng de zuòyòng xià kěyǐ xiǎnshì diànchí de `PackLotCode`,`PCBLotCode`,`gùjiàn bǎnběn `,`yìngjiàn jiàozhèng `yǐjí `diànchí jiǎozhèng `děng - běn bǔdīng láizì***VirtualSMC.Kext*** guānfāng bǔdīng bìng zuòle xiē tiáozhěng - běn bǔdīng hé `diànchí `bǔdīng wú zhǔ cóng guānxì. Fēi bìyào! - Běn bǔdīng shìyòng suǒyǒu bǐjìběn ### bǔdīng shuōmíng - zài ACPI guīfàn zhōng,`_BST`dìngyìle yīxiē diànchí xìnxī, bǔdīng zhōng tōngguò fāngfǎ `CBIS`hé `CBSS`zhùrù zhèxiē xìnxī. Yǒuguān `_BST`dìngyì de xiángxì nèiróng qǐng cháyuè ACPI guīfàn - shìlì zhōng wèi néng zhǎodào `CBSS`de shíjì yìngyòng, gù shǐyòng `Return (Buffer (Zero){})`jí kě.**Zhùyì** bùkě shānchú `CBSS`nèiróng - wèile nénggòu zài**wúxū `diànchí `bǔdīng de jīqì** shàng gōngzuò, shìlì bǔdīng zài diànchí lùjìng xià tiānjiāle B1B2 fāngfǎ ### SSDT-BATS-PRO13 shìlì - `diànchí `lùjìng:`_SB.PCI0.LPCB.H_EC.BAT1` shǐyòng shí yīng bǎozhèng yuánshǐ ACPI de diànchí lùjìng yǔ shìlì de diànchí lùjìng yīzhì - `CBIS`fāngfǎ - gēnjù `_BST`de nèiróng cházhǎo duìyìng biànliàng, àn `dī zì jié `,`gāo zì jié `xiě rù B1B2. Rú:PKG1 [0x02]=B1B2 (`FUSL`, `FUSH`), rúguǒ zhège biànliàng shì shuāng zì jié, cānkǎo diànchí bǔdīng chāi fēn shùjù de fāngfǎ jìnxíng shǔ jù chāi fēn, chóngxīn dìngyì shùjù - rúguǒ bùnéng quèrèn biànliàng, yě kěyǐ zài win huòzhě Linux xià chákàn diànchí xiāngguān xìnxī [**wèi yànzhèng**], zhíjiē tiánxiě. Bǐrú:`Gùjiàn bǎnběn `shì 123, zhíjiē lìng PKG1 [0x04] = B1B2 (0x23, 0x01) - `CBSS`fāngfǎ shùjù tiánxiě fāngfǎ tóng `CBIS`. Rúguǒ bù xūyào tiánxiě rènhé nèiróng shǐyòng `Return (Buffer (Zero){})`
Espandi
873 / 5000
Risultati della traduzione
# Patch ausiliaria per le informazioni sulla batteria

## Panoramica

-Il nuovo *** VirtualSMC.kext *** e i suoi componenti *** kext *** [dopo il 14 agosto] forniscono un'interfaccia per la visualizzazione delle informazioni ausiliarie sulla batteria. Attraverso la patch SSDT personalizzata, è possibile visualizzare "PackLotCode", "PCBLotCode", "versione firmware", "correzione hardware" e "correzione batteria" della batteria sotto l'azione del driver.
-Questa patch proviene dalla patch ufficiale di *** VirtualSMC.kext *** con alcune modifiche
-Questa patch e la patch `battery` non hanno alcuna relazione master-slave. Non essenziale!
-Questa patch si applica a tutti i laptop

### Note sulla patch

-Nelle specifiche ACPI, `_BST` definisce alcune informazioni sulla batteria, e la patch usa i metodi` CBIS` e `CBSS` per iniettare queste informazioni. Per i dettagli sulla definizione di "_BST", fare riferimento alla specifica ACPI
-Nell'esempio non è stato possibile trovare l'applicazione pratica di `CBSS`, basta usare` Return (Buffer (Zero) {}) `. ** Nota ** Il contenuto "CBSS" non può essere eliminato
-Per poter lavorare su ** macchine che non necessitano di una patch `battery` **, la patch di esempio aggiunge il metodo B1B2 sotto il percorso della batteria

### Esempio SSDT-BATS-PRO13

-`Battery` percorso: `_SB.PCI0.LPCB.H_EC.BAT1`

  Durante l'utilizzo, assicurarsi che il percorso della batteria dell'ACPI originale sia coerente con il percorso della batteria dell'esempio
-`CBIS`
  
  -Trova la variabile corrispondente in base al contenuto di "_BST" e premi "low byte" e "high byte" per scrivere B1B2. Ad esempio: PKG1 [0x02] = B1B2 (`FUSL`,` FUSH`), se questa variabile è a doppio byte, fare riferimento al metodo di suddivisione dei dati della patch della batteria per dividere i dati e ridefinire i dati
  -Se non puoi confermare le variabili, puoi anche visualizzare le informazioni relative alla batteria [** Unverified **] sotto Win o Linux e compilare direttamente. Ad esempio: "Versione firmware" è 123, impostare direttamente PKG1 [0x04] = B1B2 (0x23, 0x01)

-`CBSS`

  Il metodo di riempimento dei dati è lo stesso di "CBIS". Se non è necessario inserire alcun contenuto, utilizzare "Return (Buffer (Zero) ())"

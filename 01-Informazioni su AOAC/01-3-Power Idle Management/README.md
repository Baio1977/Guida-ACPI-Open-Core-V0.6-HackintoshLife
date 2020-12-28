## Descrizione

- Questa patch consente la gestione dell'alimentazione inattiva del sistema MAC stesso per estendere il tempo di standby in modalità batteria.
- Vedi: <https://pikeralpha.wordpress.com/2017/01/12/debugging-sleep-issues/>.

## Patch SSDT

- ***SSDT-DeepIdle*** - Patch per la gestione dell'alimentazione inattiva

## Precauzioni

- ***SSDT-DeepIdle*** e lo sleep `S3` possono avere seri conflitti, utilizzare ***SSDT-DeepIdle*** per evitare lo sleep` S3`, fare riferimento a `Sleep proibito S3`
- ***SSDT-DeepIdle*** può causare difficoltà nel riattivare la macchina. Questo problema può essere risolto tramite una patch, vedi `Patch Wake Up AOAC`

## Osservazioni

- ***SSDT-DeepIdle*** Il contenuto principale proviene da @Pike R.Alpha

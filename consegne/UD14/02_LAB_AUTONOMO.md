# UD14 — Consegna LAB autonomo

| Campo | Valore |
|---|---|
| branch | `feature/ud14-ci-v2` |
| modifica app | In `server.py` ho cambiato `APP_VERSION` da `ci-v1` a `ci-v2`, senza toccare il test |
| test fallito | `test_health_version` |
| causa | Il test si aspetta `ci-v1` ma l'app ora risponde `ci-v2` (`AssertionError: 'ci-v2' != 'ci-v1'`), cioè codice e test non combaciavano |
| modifica test | In `test_backend.py` ho cambiato il valore atteso da `ci-v1` a `ci-v2` |
| test finale | `Ran 3 tests`, `OK` |
| PR | #5 da `feature/ud14-ci-v2` verso `main`, diff controllato (due righe cambiate) e controlli verdi |
| merge | Squash and merge, titolo `Feature/ud14 ci v2 (#5)` |
| run CI | `#20260925.3`, verde (Test e BuildPush) |
| nuovo tag ACR | `catalog-backend:14`, il Build ID della run (`UD14_FINAL_IMAGE_TAG=14`) |
| cleanup eseguito | NO |

# przyklad_blok4_drugie_ci — CI repo wołające CD z zewnętrznego repo

## Opis

Repozytorium z kodem Terraform, w którym pipeline CI **sam sprawdza składnię** (fmt, validate, tflint, Trivy), a następnie **woła reusable workflow z drugiego repo** (`przyklad_blok4_drugie_cd`) do wykonania plan + apply.

### Podział odpowiedzialności

```
┌──────────────────────────────────────────────────────────────────────┐
│                    przyklad_blok4_drugie_ci                          │
│                    (TO REPO — z kodem Terraform)                    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  Workflow: ci-and-deploy.yml                                        │
│                                                                      │
│  ┌────────────────────────────────────────────────────────────────┐  │
│  │  LOKALNE JOBY (CI — w tym repo)                                │  │
│  │                                                                │  │
│  │  ┌─────────┐  ┌──────────┐  ┌────────┐  ┌───────┐            │  │
│  │  │   fmt   │  │ validate │  │ tflint │  │ Trivy │            │  │
│  │  └────┬────┘  └────┬─────┘  └───┬────┘  └───┬───┘            │  │
│  │       │             │            │            │                │  │
│  │       └─────────────┴────────────┴────────────┘                │  │
│  │                         │                                      │  │
│  │                    ALL PASSED ✅                                │  │
│  └─────────────────────────┼──────────────────────────────────────┘  │
│                            │                                         │
│  ┌─────────────────────────▼──────────────────────────────────────┐  │
│  │  ZEWNĘTRZNE JOBY (CD — z przyklad_blok4_drugie_cd)             │  │
│  │                                                                │  │
│  │  uses: ORG/przyklad_blok4_drugie_cd/.github/workflows/         │  │
│  │        reusable-plan.yml@main                                  │  │
│  │        reusable-apply.yml@main                                 │  │
│  │                                                                │  │
│  │  ┌──────┐  ┌──────────┐  ┌──────┐  ┌──────────┐              │  │
│  │  │ plan │──│ apply    │──│ plan │──│ apply    │              │  │
│  │  │ DEV  │  │ DEV auto │  │ PROD │  │ PROD ✋ │              │  │
│  │  └──────┘  └──────────┘  └──────┘  └──────────┘              │  │
│  └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

### Jak to działa?

1. **Push/PR** → CI workflow startuje
2. **Gate 1 (lokalne):** `fmt` + `validate` + `tflint` biegną równolegle w tym repo
3. **Gate 2 (lokalne):** `Trivy` security scan — czeka na Gate 1
4. **Gate 3 (zewnętrzne):** `uses: ORG/cd-repo/.../reusable-plan.yml@main` — wywołuje plan z centralnego repo CD
5. **Gate 4 (zewnętrzne):** `uses: ORG/cd-repo/.../reusable-apply.yml@main` — wywołuje apply z centralnego repo CD

### Konfiguracja

1. Oba repozytoria w tej samej organizacji GitHub
2. W repo CD: `Settings → Actions → Access → Accessible from repositories in the organization`
3. Sekrety na poziomie **organizacji** (Organization secrets) — wtedy `secrets: inherit` działa automatycznie
4. Alternatywnie: sekrety per repo i jawne przekazywanie

### Wymagania

- Zmień `TWOJA-ORG` w workflowach na nazwę swojej organizacji GitHub
- Sekrety: `AZURE_CLIENT_ID`, `AZURE_SUBSCRIPTION_ID`, `AZURE_TENANT_ID`

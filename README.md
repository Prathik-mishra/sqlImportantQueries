# Retail Customer Addition API Comparison: Turing vs Finacle

## Introduction
This document compares two APIs used for retail customer onboarding in banking systems.  
The previous source system (**Turing**) is being replaced by **Finacle**. This comparison outlines common fields, differences, and provides recommendations for mapping and migration.

---

## Common Parameters (Mapped Fields)

| Turing Field           | Finacle Field                        | Notes                                       |
|------------------------|--------------------------------------|---------------------------------------------|
| `firstNameStr`         | `FirstName`                          | Inferred from full name                     |
| `lastNameStr`          | `LastName`                           | Direct match                                |
| `middleNameStr`        | `Middlename (implied)`               | Turing explicitly mentions                  |
| `dateOfBirthDtm`       | `DateOfBirth`                        | Same meaning, different format              |
| `panNoStr`             | `EntityDoctData.DocCode = PAN`       | PAN handled as document in Finacle          |
| `aadharNoStr`          | `EntityDoctData.DocCode = AADHAAR`   | Handled as document                         |
| `mobileNoStr`          | `PhoneNumLocalCode`                  | Contact details format differs              |
| `emailIdStr`           | `PhoneOrEmail with type EMAIL`       | Finacle supports multi-channel              |
| `customerProfileCodeInt` | `Occupation`                       | Code vs numeric ID mapping                  |
| `sexCodeLon`           | `Gender`                             | Mapped M/F vs code                          |
| `NationalityCodeLon`   | `Nationality`                        | Code vs string                              |

---

## Unique Parameters in Turing API

- Wrapper: `customerIndividualOnboardingRequest`
- `PhotoUploadRequest` and `SignatureUploadRequest`
- `misCodeDetails` block
- Flat address structure (e.g., `address1Str`, `cityCodeLon`, etc.)
- Flags and tags not modeled in Finacle:
  - `introducersIdLon`
  - `guardianTypeCodeLon`
  - `ageGroupInt`
  - `form60FlagInt`, `form60ReasonInt`
  - `maritalStatusCodeLon`, etc.

---

## Unique Parameters in Finacle API

- Structured objects:
  - `AddrDtls`
  - `PhoneEmailDtls`
  - `DemographicData`
  - `PsychographicData`
  - `CoreInterfaceInfo`
- Advanced document handling:
  - `EntityDoctData[]` (e.g., PAN, AADHAAR, PASSP)
- FATCA & Foreign Tax Fields:
  - `FatcaRemarks`
  - `ForeignAccTaxReportingReq`
  - `ForeignTaxReportingStatus`
- Relationship & Segmentation:
  - `GuardianName`, `MaidenNameOfMother`, `Manager`
  - `SegmentationClass`, `SubSegment`, `TaxDeductionTable`

---

## Migration & Mapping Recommendations

- ✅ **Split Full Name**: Break `fullNameStr` into first, middle, last for Finacle.
- ✅ **Map documents**: Store PAN/AADHAAR into `EntityDoctData[]`.
- ✅ **Restructure contacts**: Move mobile/email to `PhoneEmailDtls`.
- ✅ **Use controlled code mappings** for:
  - Gender
  - Nationality
  - Religion
  - Marital status
- ✅ **Compliance fields** (FATCA, KYC) must be evaluated for values or defaults.

---

## Conclusion

Turing and Finacle both support rich customer profiles but differ significantly in structure. Migration must focus on:
- Accurate mapping of code vs string fields
- Document abstraction
- Contact and address restructuring
- Regulatory data compliance


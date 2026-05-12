# MyoTwin — System Health Tracker

## Active Health Issues

## Known Architectural Decisions

### D40
- **Decision**: TorqueCalculator uses 9.81 m/s² gravity constant
- **Status**: Implemented

### D41
- **Decision**: RingHeight lever multipliers (overhead=1.0, sternum=0.75, waist=0.6, knee=0.4, floor=0.25)
- **Status**: Implemented

### D42
- **Decision**: ProgressionLadder split at integrity=0.7
- **Status**: Implemented

### D43
- **Decision**: SafetyMargin tier boundary at 1.0 (safety < 1.0, performance ≥ 1.0)
- **Status**: Implemented

### D44
- **Decision**: Elite cue unlock requires integrity > 0.75 AND margin ≥ 0.5
- **Status**: Implemented

### D45
- **Decision**: BodySegment enum uses anatomical IDs matching GLB mesh names
- **Status**: Implemented
- **Note**: Need to verify GLB asset matches BodySegmentEnum values

## TODOs

- [ ] Verify GLB anatomical mesh names match BodySegmentEnum IDs (D45)
- [ ] Implement DatabaseIsolate in mobile/desktop data layer
- [ ] Implement DatabaseExportService in mobile/desktop data layer
- [ ] Add test scaffolds for BLoCs and use cases
- [ ] Create system_health.md in root scope

## Dependencies Check

- [ ] Verify all Flutter packages have correct versions
- [ ] Check for circular dependencies between packages

## Architecture Drift

No major drift detected. All packages follow Clean Architecture.

---

**Document version**: 1.0
**Last updated**: 2026-05-12

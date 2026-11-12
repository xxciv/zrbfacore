-- Follow-up to 2026_11_12_42: the Horde ship 269836 (guid 101352) at the Vashj'ir berth carries the Argus intro scene
-- (Fleet Admiral Zar'gov, Aethas Sunreaver, Vindicator Boros, Silgryn, Sunstrider Highguards, Kor'kron Headhunters)
-- in phase 11695, which every player in Bladefist Bay gets. With the ship hidden on "Call of Duty" they stood on the
-- water (Four, 2026-11-12). Move them to phase 307 with the ship: same audience as before (everyone in Durotar),
-- hidden while 25924 is in progress. (Vindicator Boros 3000007 in phase 8625 is a duplicate nobody can see; untouched.)
UPDATE `creature` SET `phaseUseFlags`=0, `PhaseId`=307, `PhaseGroup`=0 WHERE `map`=1 AND `PhaseId`=11695 AND `guid` IN
(401234,401249,401250,401251,401252,401253,401254,401255,401256,401257,401258,401259);

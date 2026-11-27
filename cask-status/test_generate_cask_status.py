import subprocess
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import generate_cask_status as status


def cask(token, **metadata):
    return {"token": token, "full_token": f"{status.TAP}/{token}", "tap": status.TAP, **metadata}


LATEST = cask("example@beta", version="latest", homepage="https://example.com/a(b)?x=a|b&y=2",
              deprecated=False, disabled=False)
DISABLED = cask("example", version="1|2\n<em>*x*`\\ &", disabled=True, deprecated=True,
                disable_date="2026-01-01", disable_reason="broken | unsafe")
DEPRECATED = cask("former", deprecated=True, disabled=False)
UNKNOWN = cask("unknown", homepage="javascript:alert(1)")
RECORDS = [LATEST, UNKNOWN, DEPRECATED, DISABLED]
NAMES = [record["full_token"] for record in RECORDS]
TAP_INFO = [{
    "name": status.TAP,
    "installed": True,
    "cask_tokens": NAMES,
    "cask_files": [f"/tap/Casks/{record['token']}.rb" for record in RECORDS],
}]


class CaskStatusTests(unittest.TestCase):
    def test_native_lookup_uses_sorted_qualified_tokens(self):
        with patch.object(status, "brew_json", side_effect=[TAP_INFO, {"casks": RECORDS}]) as brew_json:
            self.assertEqual(status.generate(), status.render(RECORDS))
        self.assertEqual([call.args for call in brew_json.call_args_list], [
            ("tap-info", status.TAP, "--json"),
            ("info", "--json=v2", "--cask", *sorted(NAMES)),
        ])

    def test_rendering_is_sorted_and_escapes_table_cells(self):
        report = status.render(RECORDS)
        self.assertEqual(report, status.render(reversed(RECORDS)))
        self.assertTrue(report.endswith("\n"))
        self.assertEqual(report.splitlines()[8:], [
            "| `example` | 1&#124;2 &#60;em&#62;&#42;x&#42;&#96;&#92; &#38; | — | "
            "Disabled: 2026-01-01, broken &#124; unsafe |",
            "| `example@beta` | latest | [https://example.com/a&#40;b&#41;?x=a&#124;b&#38;y=2]"
            "(<https://example.com/a(b)?x=a%7Cb&amp;y=2>) | Active |",
            "| `former` | — | — | Deprecated |",
            "| `unknown` | — | javascript:alert&#40;1&#41; | Unknown |",
        ])

    def test_missing_or_incomplete_tap_is_rejected(self):
        for response in ([], [None], [TAP_INFO[0], TAP_INFO[0]], *[
            [{**TAP_INFO[0], **override}] for override in (
                {"name": "other/tap"}, {"installed": False}, {"cask_tokens": None}, {"cask_tokens": []},
                {"cask_tokens": ["example"]}, {"cask_tokens": [*NAMES, NAMES[0]]},
                {"cask_tokens": NAMES[:-1]}, {"cask_files": None},
            )
        ]):
            with self.subTest(response=response), self.assertRaises(ValueError):
                status.tap_tokens(response)

    def test_incomplete_or_unexpected_lookup_is_rejected(self):
        for records in (None, [], RECORDS[:-1], [*RECORDS, LATEST], [*RECORDS, cask("extra")],
                        [{**LATEST, "tap": "other/tap"}, *RECORDS[1:]],
                        [{**LATEST, "token": "wrong"}, *RECORDS[1:]]):
            with self.subTest(records=records), self.assertRaises(ValueError):
                status.cask_records({"casks": records}, NAMES)

    def test_errors_leave_previous_report_untouched(self):
        with tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "report.md"
            output.write_text("previous report\n", encoding="utf-8")
            with patch("sys.argv", ["generate", "--output", str(output)]), patch("sys.stderr"):
                for response in (TAP_INFO, subprocess.CalledProcessError(1, "brew", stderr="error")):
                    with self.subTest(response=response), patch.object(
                        status, "brew_json", side_effect=[response, {"casks": []}],
                    ), self.assertRaises(SystemExit) as error:
                        status.main()
                    self.assertEqual(error.exception.code, 1)
                    self.assertEqual(output.read_text(encoding="utf-8"), "previous report\n")


if __name__ == "__main__":
    unittest.main()

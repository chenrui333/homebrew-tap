import json
import tempfile
import unittest
from pathlib import Path

from generate_formula_status import FormulaCrawler, FormulaInfo, GitStats


class CoreReadinessTest(unittest.TestCase):
    def setUp(self):
        self.crawler = FormulaCrawler(refresh_cache=True)
        with tempfile.TemporaryDirectory() as tmp:
            index = Path(tmp) / "formula.json"
            index.write_text(json.dumps([{
                "name": "new-tool",
                "aliases": ["short-tool"],
                "oldnames": ["old-tool"],
                "urls": {"stable": {"url": "https://github.com/team/project.tool/archive/v2.tar.gz"}},
            }]))
            self.index = self.crawler.load_core_index(index)

    def test_same_project_via_former_name(self):
        formula = FormulaInfo("old-tool", url="https://github.com/Team/project.tool/archive/v1.tar.gz")
        status, action = self.crawler.core_screen(formula, self.index)
        self.assertEqual(status, "Core overlap candidate")
        self.assertIn("new-tool", action)
        self.assertIn("former name", action)

    def test_alias_for_different_project_is_not_a_replacement(self):
        formula = FormulaInfo("short-tool", url="https://github.com/team/project.other/archive/v2.tar.gz")
        status, action = self.crawler.core_screen(formula, self.index)
        self.assertEqual(status, "Core name collision")
        self.assertIn("(alias)", action)

    def test_hello_is_preserved(self):
        self.assertEqual(self.crawler.core_screen(FormulaInfo("hello"), self.index)[0], "Preserve")

    def test_cached_popularity_is_only_a_candidate(self):
        formula = FormulaInfo("tool", license="MIT", git_stats=GitStats(stars=75, hosting="github"))
        status, action = self.crawler.core_screen(formula, self.index)
        self.assertEqual(status, "Notability candidate")
        self.assertIn("Core CI", action)

    def test_report_distinguishes_skip_from_default(self):
        with tempfile.TemporaryDirectory() as tmp:
            recipe = Path(tmp) / "tool.rb"
            recipe.write_text('class Tool < Formula\n  livecheck do\n    skip "No releases"\n  end\nend\n')
            formula = self.crawler.process_formula(recipe)
        report = self.crawler.generate_report([formula, FormulaInfo("other")], self.index)
        self.assertIn("| skip | Blocked |", report)
        self.assertIn("| default | Needs license review |", report)


if __name__ == "__main__":
    unittest.main()

import json
import subprocess
import tempfile
import unittest
from pathlib import Path

from tests.builder.fakes import FakeBin

SCRIPT = Path(__file__).resolve().parents[2] / "website" / "scripts" / "bottles.sh"
RELEASES = ["gh", "api", "--paginate", "repos/macos-intel/homebrew-tap/releases?per_page=100"]


def release(tag: str, published: str) -> dict:
    url = f"https://github.com/macos-intel/homebrew-tap/releases/tag/{tag}"
    return {"tag_name": tag, "draft": False, "html_url": url, "published_at": published}


class BottlesTest(unittest.TestCase):
    def bottles(self, releases: list[dict]) -> dict[str, dict]:
        with FakeBin() as fake, tempfile.TemporaryDirectory() as directory:
            output = Path(directory) / "bottles.json"
            fake.respond(*RELEASES, stdout=json.dumps(releases))
            env = {**fake.environment(), "BOTTLES_OUTPUT": str(output)}
            result = subprocess.run(["bash", str(SCRIPT)], env=env, capture_output=True, text=True, check=False)
            self.assertEqual(result.returncode, 0, result.stderr)
            return {entry["name"]: entry for entry in json.loads(output.read_text(encoding="utf-8"))}

    def test_version_with_a_hyphen_keeps_its_formula_name(self):
        older = release("luv-1.53.0-0", "2026-10-01T00:00:00Z")
        bottles = self.bottles([older, release("luv-1.53.0-1", "2026-10-02T00:00:00Z")])
        self.assertEqual(bottles["luv"]["version"], "1.53.0-1")
        self.assertNotIn("luv-1.53.0", bottles)

    def test_longest_formula_name_wins(self):
        bottles = self.bottles([release("openjdk@21-21.0.13.0.3", "2026-10-01T00:00:00Z")])
        self.assertEqual(bottles["openjdk@21"]["version"], "21.0.13.0.3")
        self.assertEqual(bottles["openjdk@21"]["deps"][:1], ["freetype"])

    def test_release_of_a_formula_no_longer_in_the_tap_is_dropped(self):
        gone = release("gone-1.0", "2026-10-01T00:00:00Z")
        bottles = self.bottles([gone, release("lz4-1.10.0", "2026-10-01T00:00:00Z")])
        self.assertEqual(sorted(bottles), ["lz4"])


if __name__ == "__main__":
    unittest.main()

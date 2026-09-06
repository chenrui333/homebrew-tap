class Swpui < Formula
  desc "Interactive search and replacement preview"
  homepage "https://github.com/beeb/swpui"
  url "https://github.com/beeb/swpui/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "517a8f19498d3e5d689baabb7e48001aba81042c727010491fec27c092cd236d"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/beeb/swpui.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # TODO: Upstream does not expose a version command.
    # FIXME: Replace the terminal startup failure check when upstream adds a headless preview mode.
    output = shell_output("#{bin}/swp </dev/null 2>&1", 1)
    assert_match version.to_s, output
    assert_match "Failed to initialize input reader", output
  end
end

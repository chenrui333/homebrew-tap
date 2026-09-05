class Spectatui < Formula
  desc "Terminal dashboard for GitHub Spec-Kit"
  homepage "https://github.com/tinesoft/spectatui"
  url "https://github.com/tinesoft/spectatui/archive/refs/tags/v1.0.1.tar.gz"
  sha256 "bc0eab9e1af23bfaa14cc24a9dd73bc487636e37665947c125b2b3e0a2c2d005"
  license "MIT"
  head "https://github.com/tinesoft/spectatui.git", branch: "develop"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/spectatui")
  end

  test do
    # TODO: Upstream does not expose a version command; add a version assertion when available.
    output = shell_output("#{bin}/spectatui --project #{testpath}/missing 2>&1", 1)
    assert_match "failed to discover project", output
    assert_match "project root not found", output
  end
end

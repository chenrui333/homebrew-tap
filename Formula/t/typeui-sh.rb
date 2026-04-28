class TypeuiSh < Formula
  desc "Generate design-system skill markdown files for AI providers"
  homepage "https://www.typeui.sh"
  url "https://github.com/bergside/typeui.sh/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "7f4722a087c62764c55721ca67a76b1c80593665482d71032c10e270d7e7a6f6"
  license "MIT"
  head "https://github.com/bergside/typeui.sh.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "66eb3bb3bb8ae8d9ebbbd2546fd79229bb9223740026c53f11971b7be68e56fe"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(prefix: false), "--include=dev"
    system "npm", "run", "build"
    system "npm", "pack"
    system "npm", "install", *std_npm_args, "typeui.sh-#{version}.tgz"

    bin.install_symlink libexec/"bin/typeui.sh"
  end

  test do
    (testpath/".typeui-sh").mkpath
    (testpath/".typeui-sh/license.json").write <<~JSON
      {
        "productId": "typeui.sh",
        "verifiedAt": "2026-03-07T00:00:00.000Z",
        "expiresAt": "2999-01-01T00:00:00.000Z",
        "licenseKeyFingerprint": "deadbeefdeadbeef"
      }
    JSON

    assert_match "deadbeefdeadbeef", shell_output("#{bin}/typeui.sh license")

    assert_match "Cleared local cache state.", shell_output("#{bin}/typeui.sh clear-cache")
    assert_match "No cached license.", shell_output("#{bin}/typeui.sh license")
  end
end

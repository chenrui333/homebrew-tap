class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.6.0.tar.gz"
  sha256 "f63b59a41da890037661ee3bf660984765a1d4e67ab7aad12a7756eb43524709"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc52513633c26d36503b68d09dbc1bd2003a307ae6c906ede4e73400818757db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a56b72191be702ae369be245c535fb7332b7b920ce19f1406a67cbacde15bac9"
    sha256 cellar: :any_skip_relocation, sequoia:       "3e00bc94f885fbe8683914e7e20b1e472c9ebf3c2da6133c3ffda25c0f93401f"
  end

  depends_on xcode: ["16.0", :build]
  depends_on :macos

  on_macos do
    depends_on macos: :sequoia
  end

  def install
    system "swift", "build", "--disable-sandbox", "-c", "release"
    bin.install ".build/release/ctxmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctxmv --version")
    output = shell_output("#{bin}/ctxmv list --source codex --project #{testpath} --limit 1")
    assert_match "No sessions found.", output
  end
end

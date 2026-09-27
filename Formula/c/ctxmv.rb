class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.7.0.tar.gz"
  sha256 "936553f768986eb5de125b2740ec9261de26fb7de114fbea3cbd6ae738ef4692"
  license "MIT"
  head "https://github.com/Ryu0118/ctxmv.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f68a96905615c5bd089617252f108c4115aa68d5fcaa8cea3806d205ae4e5bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d685e0ebeaa825ef30979a038c36764fbb31f922498efb2ed46b2786a015e1cf"
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

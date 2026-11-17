class Ctxmv < Formula
  desc "Migrate conversation sessions between AI coding agents"
  homepage "https://github.com/Ryu0118/ctxmv"
  url "https://github.com/Ryu0118/ctxmv/archive/refs/tags/0.7.1.tar.gz"
  sha256 "649d8f007b332ac9499be6656acf349e188f4342fd80ce75c6cfcb5611b5ccde"
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

  on_sequoia do
    # swift-log 1.16.2 requires Swift 6.2; Sequoia's default Xcode ships Swift 6.1.
    depends_on "swift"
  end

  deny_network_access!

  def fetch
    # SwiftPM tries to apply its own sandbox, which cannot nest inside the
    # build sandbox; Homebrew's sandbox still confines the whole process.
    system swift_executable, "package", "resolve", "--disable-sandbox"
  end

  def install
    swift = swift_executable
    args = ["build", "--disable-sandbox", "-c", "release"]
    if MacOS.version == :sequoia
      info = JSON.parse(Utils.safe_popen_read(swift, "-print-target-info"))
      runtime = Pathname(info.fetch("paths").fetch("runtimeResourcePath"))/"macosx"
      args += ["-Xlinker", "-rpath", "-Xlinker", runtime]
    end
    system swift, *args
    bin.install ".build/release/ctxmv"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ctxmv --version")
    output = shell_output("#{bin}/ctxmv list --source codex --project #{testpath} --limit 1")
    assert_match "No sessions found.", output
  end

  private

  def swift_executable
    on_sequoia { return formula_opt_bin("swift")/"swift" }
    "swift"
  end
end

class Pitchfork < Formula
  desc "Daemons with DX"
  homepage "https://github.com/endevco/pitchfork"
  url "https://github.com/endevco/pitchfork/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "3c903458db95d208ad8852b938a272eb9fde005223c5e3867ea10fe9daa2e424"
  license "MIT"
  head "https://github.com/endevco/pitchfork.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "37d615ea61b8a9b24573cff5d73e05a713a27e586481f39d9bdf91983d980bef"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4572ae72937d876100fb9abcf9d8f00b3f834f41ddb9e22659e75736fd221d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db1d73da4cb2a5049059f26870e5c621a22f082d805bc596862466868fff60e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b5df996e1c61f50e2af45fd42d0504f0d31933c65857f85c8847a68e8a25754f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ac568e9b61b02cbf0a04f52001ec116fbdffaac26328ec8015dc5835a39ec725"
  end

  depends_on "rust" => :build
  depends_on "usage" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"pitchfork", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pitchfork --version")

    (testpath/"pitchfork.toml").write <<~TOML
      [daemons.test]
      run = "echo hello"
    TOML
    output = shell_output("#{bin}/pitchfork list 2>&1")
    assert_match "test", output
  end
end

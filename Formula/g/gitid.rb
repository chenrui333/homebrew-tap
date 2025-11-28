class Gitid < Formula
  desc "Tool to stop sending work commits with your personal email"
  homepage "https://github.com/nathabonfim59/gitid"
  url "https://github.com/nathabonfim59/gitid/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "28e9760e884bafadcf31d898abd8dd0b03f0af3b0beb807ae16a7ab357a103ed"
  license "MIT"
  head "https://github.com/nathabonfim59/gitid.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de25a5ab58a1ddd8493182436cb3a09bfcfc54f1016f8f7bfa51832984e265d9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "de25a5ab58a1ddd8493182436cb3a09bfcfc54f1016f8f7bfa51832984e265d9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "de25a5ab58a1ddd8493182436cb3a09bfcfc54f1016f8f7bfa51832984e265d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d0b7286aead4baaa56feca863ca78f49cad9bc82093bad558f68420ef9db7146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d441c479c4a730b44795b790f5956059f4e6b9eac518bfec2a1127d4e3ad75f2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")

    # generate_completions_from_executable(bin/"gitid", "completion")
  end

  test do
    assert_match "No identities configured", shell_output("#{bin}/gitid list")
    system bin/"gitid", "add", "BrewTest", "test@brew.sh", "homebrew"
    assert_match "BrewTest", shell_output("#{bin}/gitid nickname test@brew.sh homebrew")
  end
end

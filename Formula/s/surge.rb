class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "952ef5c75e8de4500990de65c1c41305458c76cbdd0c268e6a03eacd03a7c953"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "61ae3f824cfe17fa9787d7124db14b5be4b00453b6764b7fcf22b96b28b618b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "61ae3f824cfe17fa9787d7124db14b5be4b00453b6764b7fcf22b96b28b618b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61ae3f824cfe17fa9787d7124db14b5be4b00453b6764b7fcf22b96b28b618b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "69b003e4c6dadcd7db4ebc63e455c1d2de6eb2cce9107077f251f7e1d3e58394"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1a1dfb8a510dbdf03311f4b72ed86da84297e9e7366568dddfeefd1ac859492"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/surge-downloader/surge/cmd.Version=#{version}
      -X github.com/surge-downloader/surge/cmd.BuildTime=homebrew
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"surge"), "."
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/surge --version")

    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    ENV["XDG_STATE_HOME"] = testpath/".local/state"
    ENV["XDG_RUNTIME_DIR"] = testpath/".runtime"

    token = shell_output("#{bin}/surge token").strip
    assert_match(/\A[0-9a-f-]{36}\z/, token)

    assert_path_exists testpath/".local/state/surge/token" if OS.linux?
  end
end

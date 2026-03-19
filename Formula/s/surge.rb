class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.7.2.tar.gz"
  sha256 "053b227a19b92a4079f95a64f719ab0a458f7f36a721e68d1ee31df680f992dc"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9737b164035a8c28d480f3673d40ec208b066db061e93e3d29d8c949a921173b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9737b164035a8c28d480f3673d40ec208b066db061e93e3d29d8c949a921173b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9737b164035a8c28d480f3673d40ec208b066db061e93e3d29d8c949a921173b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a63948c8dd21de823cddc616f4a167a59f0283be0388eeec85898f1bde410ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2eed91edc4f0fbd49ac410c3f4cd4cbd658ed23b950edf21f76d4b0587d2badc"
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

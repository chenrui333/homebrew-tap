class Surge < Formula
  desc "Blazing fast TUI download manager"
  homepage "https://github.com/surge-downloader/Surge"
  url "https://github.com/surge-downloader/Surge/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "317183ecc2589a407baae10e3e892be4df21171c1bdf0bbc41053f8be910f771"
  license "MIT"
  head "https://github.com/surge-downloader/Surge.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f90c6d77dd1ed33b6f578b7511984b553f9dc42b1ff7f8d2d408951beb2049e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f90c6d77dd1ed33b6f578b7511984b553f9dc42b1ff7f8d2d408951beb2049e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5348cb9724c842292dc7934f720ceec348b221b3d946baef7309b9026f5eb86"
    sha256 cellar: :any,                 x86_64_linux:  "234394c65550af51b64d0513158e31caee6c128fe3601401f80b95d37abd7af4"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -s -w
      -X github.com/SurgeDM/Surge/cmd.Version=#{version}
      -X github.com/SurgeDM/Surge/cmd.BuildTime=homebrew
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

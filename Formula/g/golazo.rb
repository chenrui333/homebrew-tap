class Golazo < Formula
  desc "Minimal TUI app to follow live and recent football matches"
  homepage "https://github.com/0xjuanma/golazo"
  url "https://github.com/0xjuanma/golazo/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "209c10532859e79c74348b5ac93a6303741e1fb4283fe399425e6981ff3b5b9f"
  license "MIT"
  head "https://github.com/0xjuanma/golazo.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8eea3945f4b42e6d44dee20881d40e0608e787013bf791817d0842b744fe1e5f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8eea3945f4b42e6d44dee20881d40e0608e787013bf791817d0842b744fe1e5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8eea3945f4b42e6d44dee20881d40e0608e787013bf791817d0842b744fe1e5f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a4598eeb50261346697e045a3c369c3e6b96b6e6cef1ddcca59f47926350c2c"
    sha256 cellar: :any,                 x86_64_linux:  "7880bdd14893ff7dca1d7f8eea27269eb5a68dea7636fb2e4e438f04b7dbcff8"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/0xjuanma/golazo/cmd.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/golazo --version")

    output = shell_output("#{bin}/golazo --definitely-invalid-flag 2>&1", 2)
    assert_match "unknown flag", output
  end
end

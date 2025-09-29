class Psq < Formula
  desc "Lightweight postgres monitor for the terminal"
  homepage "https://github.com/benjaminsanborn/psq"
  url "https://github.com/benjaminsanborn/psq/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "d17d056ec599452024829709b2942d1416af2e62d47babc9ed387122118617db"
  license "Apache-2.0"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6a4940ab5cd3cd7a58741b2e6f748298d2d6a2b4955f5309aba43d4130240b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eb06eaeaf46487df508a3fd3d3d433f26050f552a91a1209811504aae15ead38"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e1b5859b12158c2290db7104cbf4cbd9b7e759cc89a2c723073c70337af61c7f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    # Fails in Linux CI with `/dev/tty: no such device or address`
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    begin
      output_log = testpath/"output.log"
      pid = spawn bin/"psq", testpath, [:out, :err] => output_log.to_s
      sleep 1
      assert_match "Initializing", output_log.read
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end

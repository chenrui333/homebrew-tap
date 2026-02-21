class Dumper < Formula
  desc "CLI utility for creating database backups"
  homepage "https://elkirrs.github.io/dumper/"
  url "https://github.com/elkirrs/dumper/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "c6c80041434b24a61448a609193d411930b2243cb9b1047481620fc7be9c6410"
  license "MIT"
  head "https://github.com/elkirrs/dumper.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "85406c197dfb957ea32ae01b5b7ba3d43352a5055c48a0e1d5270a9975e352a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85406c197dfb957ea32ae01b5b7ba3d43352a5055c48a0e1d5270a9975e352a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "85406c197dfb957ea32ae01b5b7ba3d43352a5055c48a0e1d5270a9975e352a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca4b5dac2f151c6878b6c2228935c5001227d5ef6a65fd653e4ef35b4f2ab9e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2357d2bf02747c95715a8c22cca20ee30e8d62db7e16d968ea0f75460adc2a0f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dumper --version")
    cmd = "#{bin}/dumper -config ./notfound.yaml -all=true 2>&1"
    assert_match "configuration loading error", shell_output(cmd, 1)
  end
end

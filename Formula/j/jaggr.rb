class Jaggr < Formula
  desc "JSON Aggregation CLI"
  homepage "https://github.com/rs/jaggr"
  url "https://github.com/rs/jaggr/archive/refs/tags/1.0.1.tar.gz"
  sha256 "3277e0b459cc5930e504faa8719c61327fd69c4f840bbc6a08ddd78f6f0e8c0c"
  license "MIT"
  head "https://github.com/rs/jaggr.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a3dbf22d1b627f10029b65a033681152f8761d1f14627e41066ac6745dbab5d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0391e19e39995633dbe2c8de204cb41f6d562cb89dcbae83b309ae718b80f698"
    sha256 cellar: :any_skip_relocation, ventura:       "5a3f081945d36e6094dd061b2c333386e23023dfd60f16f135155af46761cca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e38bc778f62087c914f7123be4f8ebe2827ba3473281c066aa7db7339cb7ee9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jaggr -version 2>&1")
  end
end

class ViMongo < Formula
  desc "MongoDB TUI designed to simplify data visualization and quick manipulation"
  homepage "https://github.com/kopecmaciej/vi-mongo"
  url "https://github.com/kopecmaciej/vi-mongo/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "298b6553a576716086def2828588552cfd11c4ca783b53b5c35659c5e73fb06c"
  license "Apache-2.0"
  head "https://github.com/kopecmaciej/vi-mongo.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bee92eb5611460fcde5374b0c49a6a1913ba5feefe0e2946230253030cb5d74"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bee92eb5611460fcde5374b0c49a6a1913ba5feefe0e2946230253030cb5d74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bee92eb5611460fcde5374b0c49a6a1913ba5feefe0e2946230253030cb5d74"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9852f64aa2f011173492f0c2a405f19cba05ca828b96843fe95d43896c1cf52d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5faf429da88179895829d13b5ea8f79c66c82b0f39b6e3967242a3a02264ad9b"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/kopecmaciej/vi-mongo/internal/build.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin/"vi-mongo"} --version")
    assert_match "No connections available", shell_output("#{bin/"vi-mongo"} --connection-list")
  end
end

class Gokin < Formula
  desc "AI-powered CLI assistant for code"
  homepage "https://gokin.ginkida.dev"
  url "https://github.com/ginkida/gokin/archive/refs/tags/v0.78.0.tar.gz"
  sha256 "1075d75b8f566e70c5316b98d5a551bbca7e01e89383d4bbc8d6d90bb3358a67"
  license "MIT"
  head "https://github.com/ginkida/gokin.git", branch: "main"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d16a85f292aae7f7f4a5defc781f0819dc151f5af5c1458c0571894dbc239ccb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d16a85f292aae7f7f4a5defc781f0819dc151f5af5c1458c0571894dbc239ccb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d16a85f292aae7f7f4a5defc781f0819dc151f5af5c1458c0571894dbc239ccb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25d923cbb3ba81f195617487e8d0135c9724d37ce291cdf1f1334778d2106f14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cd43e14e90a0c257cecaf1713c68eb10d6f777802cc395604ec4e3eb8481b87"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gokin"

    generate_completions_from_executable(bin/"gokin", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gokin version")
    assert_match "Available Commands:", shell_output("#{bin}/gokin --help")
  end
end

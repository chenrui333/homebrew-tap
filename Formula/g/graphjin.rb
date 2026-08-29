class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.67.tar.gz"
  sha256 "e17706026013b79aa6a3bd9c1628bcc9d3c2ec5b3604754e4fb6b9a8778df2a4"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a8509c8f576c29cfd9caf7fb2729e4f7a5d8202c70a54e52db8457a2bc80ee4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ff369ad4ecc14b587be4ff2088638d68b8c588fea4aae67af859a474a0043225"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "458f8894311c2fd3b5c1a52d0b2f9433cba966e5ff8f8e8c8ceb18bfa72846b3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61a85d74af22ddcd5ebb49a83e05ad7ced11548bc939650e771cf471265bb30a"
    sha256 cellar: :any,                 x86_64_linux:  "177637430b68034490e93534057f3e9f8663fa9cc2b3e09a62217f8a4d02ca8b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X github.com/dosco/graphjin/serv/v3.version=#{version}
    ]

    cd "cmd" do
      system "go", "build", *std_go_args(ldflags:)
    end

    generate_completions_from_executable(bin/"graphjin", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/graphjin version")

    system bin/"graphjin", "serve", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end

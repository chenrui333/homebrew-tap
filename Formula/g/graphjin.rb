class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.23.tar.gz"
  sha256 "4f12118f01842641e4a4ab1ef2ae96e4ea6c996f694df27538c672b8dfd04e9f"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "925fef480a93f6cc289ef1e1d5461bae5c3ff7dbb41d1af98c03d9d3630fec03"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8b5dbcdaa1124c96e0182c725678930d745cfdfb225bbba83ace53f9466802d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8c8664fd9c95b80df7d924e4c0db6a0cac8c3be9a080d62363fc2814f21ece2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8735a6b43b04724e04437818d55d1a8d525c44c0fbda1335b78b8dad2fadb215"
    sha256 cellar: :any,                 x86_64_linux:  "b9efd7f4964979fed8497148da08f9b02340bde199afe02efbfa66d6282d86d3"
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

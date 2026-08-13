class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.16.tar.gz"
  sha256 "253b03a71e7327d9218a36974c420fc52737d3a479a61e712f86066a1d311934"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f59811d086d5ba7738c168b3377a72891605458f0ab47b1f17a102c978a01617"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8be61e4a053b8b8f5ee72fe82271f872773d09447e4c296849328f978135b2c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ccc1679cef2cfa2176ec8ed14569445d26e0007bfc060d7bf28f0d9a8b0b47d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf3831b434a3a9454b44aece1aebbc724238cc19ad322932673073fc636b9d46"
    sha256 cellar: :any,                 x86_64_linux:  "4d2e91a840f9927fde18d063d7a76815588a20abc2cba697602b4c5006944653"
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

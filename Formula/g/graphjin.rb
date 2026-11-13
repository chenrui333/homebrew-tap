class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.20.tar.gz"
  sha256 "4989a0ef83bbd6fee6fab2174b7967d78d4fa0ae6fcae2aac5de470594cc47e3"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "252996685920218b19426bbb69106b7d6286314fbfa031a777e4672907ffabda"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00af20ac05c96790bf67deafe2c8e741cc4d01bd965d97aa9cddeec5301b747a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9492e49a5fbe386a005a56f4f2cea8d2aa910d45f1b808e291d26d699a42da2a"
    sha256 cellar: :any,                 x86_64_linux:  "80ccbcf51b0c553e019b24f38c98dae8bc294ab3f9a9a26dd96fc3e19647e42b"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    cd "cmd" do
      system "go", "mod", "download"
    end
  end

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

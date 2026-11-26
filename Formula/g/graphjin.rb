class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.23.1.tar.gz"
  sha256 "5378e0d9b2728b24f7be8e44e4624ae1c33ce9d9d731ca934ad7ac919a7c41e0"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "c371a84bce639d3dd2d843e593d3bb6d79126ad9fad4d49ddc2920eeeff25d0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5bbb90e6e348a5fa6d3037ec0d0cb6d39abfeb8abdb4c69c4ca64715894c46a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94888dbec95e59eddfd986a7bc7d66b66ebe1ee0e0c3c3529447560785621647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3794d3b049ae5651386caea06e1ae9fe108e3129a0ec0b43477ddc665a9a2cc4"
    sha256 cellar: :any,                 x86_64_linux:  "ee14ecf965c88507478e6fdc036e2b236bfcf2a2127fb527a41bfda7c91fa944"
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

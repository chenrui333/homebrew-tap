class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.8.tar.gz"
  sha256 "f27721e1543795196cfc80c7accf82c74b52d31539bfa3e3052b914de2c7da9c"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "934a05257e0ad461a9c98896ee8bb67beaa4dd4c2ef30cc1f9cafdf2a1fdf9a5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6220f8f1e83066bcd9fd8f7345555e1e0b0c92212013c393f5f605d97983963a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d4d8f4bf58db7e0330dd0103e4982a8fab1c672ac02b5371ed1dee830601747"
    sha256 cellar: :any,                 x86_64_linux:  "cd0acea542727e1b3e62833a6f90aae46e3e22f354583641e4567da0b19af3f7"
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

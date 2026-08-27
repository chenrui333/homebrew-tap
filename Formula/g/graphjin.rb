class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.62.tar.gz"
  sha256 "d2180d906ca64cf61ee4d3fe3ffafa6b89cd615d14af8f86aed1e4df8a197f92"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6bb43456da59411836c3e8ec3fe9ca4b8df894a3e646a8c7c31a53d672b5b672"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bf4b9670d4ecb0217e7810cb6c0f9c185995200cc3d995ccd4670e3481fb73b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc90ebf1fdb9922a97662e5d0c45b954559bd81bd958a192de8321ad7e09136a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a676520111722453f40036b8a95de9142b87b1762514511580098a8a575df9cc"
    sha256 cellar: :any,                 x86_64_linux:  "e04705bd0c7b980a1f9e4314d7bee2d561d32fc6941567ad9f29320640a35e18"
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

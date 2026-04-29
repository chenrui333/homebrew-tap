class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.7.tar.gz"
  sha256 "5b60cb29885387972ec619b1414c96f04f13257758ea19225f806c868dc75bde"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b34547cb0488fd31c0e7576c8bc0c581dad68b9a417208bea56ddaf40bdbe44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95a275df52df7dd16ff3f5e9e06cb734e0b7870d14567254b848b18e53e754a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fd2492c5a4164810231cdfcb7d452b154b9673073a0bb577feef2ce27812e00"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "34e49428f55500d3c6473428eb396739b97e7899b83b613370086353f0b3bf16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "953b232a16ca9b7e271cae94d1f0be7a5a30195b324fd285e39ca4b419e9724b"
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

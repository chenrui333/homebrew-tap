class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "f6ef86d627a5d397ad7a082a0468e8ccee3fe48b78c7bdda8d0a5dbe5c7d22db"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c651a2dfcb07ccfbd8337ada1b217961ab4c58721df104edd43b98cb8c72c5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42aa2f0fb3d205aa72052d3a83c92ec2e907a8926e30abaf038d75dc0fb36500"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3943057474e4a1d3f41bb7d792eb308e6a88048648015720442c6ab6ccb37fbc"
    sha256 cellar: :any,                 x86_64_linux:  "3ceb79b15c826da59a8c4b1cc9ad0dc9be638b58e8d739b8c2ccfbfcd386e2a0"
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

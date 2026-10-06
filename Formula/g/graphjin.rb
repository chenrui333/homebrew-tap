class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.2.tar.gz"
  sha256 "f6ef86d627a5d397ad7a082a0468e8ccee3fe48b78c7bdda8d0a5dbe5c7d22db"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c52b94340680c0d15a287248b033f9b2181f568dcbdc7aeeaf5f46d643ef0d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b3b801152bd7a8619fdf1de9c70c7156fe1f1398519ee50745c43ea3b51b5fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "391ecab48ef23980817a87b1966e778b74beca426c159d75250af5dcd5d7938f"
    sha256 cellar: :any,                 x86_64_linux:  "1a5f10d4d10409a0e56fee5d57456955f5a58c8e42daea212f63db6ca2a841c1"
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

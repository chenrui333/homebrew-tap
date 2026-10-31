class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.18.tar.gz"
  sha256 "36237ee6acdaf023d7d867228caea6d2930b605e023b79635789c9632d8a88ff"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10aeb44772d4b0de023f5e332350ebe2ce80d70a52bbc80fe902bf874ed827a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1f28abaaf601b4e0a1cc0a22700f813080c820b0b9eb0c90ef3c19c723f31f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c364dfc73d6fc040da4f5bdd62f436dcd5d226975d2bb33a89a38f5669850db"
    sha256 cellar: :any,                 x86_64_linux:  "a569ae9166b338c27da8eff55aa8e22f77ffd02d0dfda159fb72a884c4629437"
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

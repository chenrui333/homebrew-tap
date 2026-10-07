class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.21.3.tar.gz"
  sha256 "fa9cb71ec6f9ec177dd30638ff714260ae1671c1d040d9308d59760fb7d4f409"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a7282ab2d6860d76be40bc0a5ae785c6893cbffbe031942173aa42b9636eba3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "82c0bb83ee1eaf84128e3f746f6ebc07292fabb37fe93d714473085410845951"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92eae75a71fb25d6b67429610230047cdced90494ea3b94dca4da03e53f59fe9"
    sha256 cellar: :any,                 x86_64_linux:  "1ebae6869536eb332345bf6f6beb4cbb74c65e7a710e7f6a6bd617951287412b"
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

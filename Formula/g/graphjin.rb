class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.25.0.tar.gz"
  sha256 "6d75c0aed9290e27d3aa4e7d1eada12348ad3cbbb605c422fd7835bc574d1f31"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    manifest_sha256 "ace74bf959bbba38823c46cfa8f3a42965b5ead62ef463e2c144e2a599fe162a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef81225c047d99a375bafc444685f7a388d8cd09cc3f642e7a5da5733cd66e57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6daae0fcc4e525978229d7673fe13fed9294ef23af8c5b4f796c1acc55a6f442"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d689541fcfdc272767ee78cd05abe0e2ad67b5d726a2bbb2c2488992c3bd460"
    sha256 cellar: :any,                 x86_64_linux:  "29f7787cba062468467577c8263fd15a2d5c956c3bc0dd796eaf12d55b580407"
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

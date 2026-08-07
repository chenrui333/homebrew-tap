class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.20.8.tar.gz"
  sha256 "698024d55d01d167e384a7d6a210978246babfe9407ed26be67343ed80a0815a"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "402bd6b6b7ca015fe43845e79b365d23e941abc33fffd155684564747ebf1dec"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b4ccd83debbc9cfdff83f12550fea343e4528f78cafb0871ac62ae9ac10458e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "174cde7789e3faafb014771ae23fd92703405613f80be46946116c028fb225e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9997d1ff27cda56ea57c542dd934a6edd31bd2b45de554e2a1afe0de4e5ae6c4"
    sha256 cellar: :any,                 x86_64_linux:  "d654e62e6dcc5e87083ca224815d284bd600331b633ebbdb018d7c783668185f"
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

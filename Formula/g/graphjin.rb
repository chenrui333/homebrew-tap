class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.3.1.tar.gz"
  sha256 "b128c65b06862b5d930db4091ba3bf274756fc62e1785eff7a45b5d47c4db905"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e9cbcdf8231d21c09ead5bc2c059ce62e6778aba37f4ec37f806cc383972b4f8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c1e31a72709ea7d5ca316ee6e9ae4075213b4d0b7e3b305ae45898b351198e93"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c81842ea10c61184c94de91954ebb58ea83bbd524a4628d1f99de89c5d76c078"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb6707f3a9e68a039492a743914b242b41ca0ea1d8df1ba52c7d5b53aaeb56c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efa38e23cab9878fd0c0e7c5eae922bd86af62c348f3882fc2d7f74e98e087e0"
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

    system bin/"graphjin", "new", "myapp"
    assert_path_exists testpath/"myapp"
    assert_match "app_name: \"Myapp Development\"", (testpath/"myapp/dev.yml").read
  end
end

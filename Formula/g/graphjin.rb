class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.45.tar.gz"
  sha256 "d38f8e245d4a7806ad21c4f36d02b2a8924c180f8ff84a24ddce8a1ac60a23a7"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "498ef87ae309839aa4454d709c578c7f4fa5178f4cc31d27e1930a0d6cbb5a28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d55605d4aa05338c4242586ffb28894deb2d91308522720eedc09761fcd095cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "93012bf341e5b67e5e58a774834c70009e5f4b8857a2ca0d6128d28af0f2c23a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81072676be928965f554311f081393553ee26ece18f63c00dc79e4ad47513e20"
    sha256 cellar: :any,                 x86_64_linux:  "0aea6ea578d26a022cf51633b3a03b7f55e9d8ab05f5f0e42781468ab885965f"
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

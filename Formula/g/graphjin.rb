class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.10.1.tar.gz"
  sha256 "bb6a67b21e2d19dffdeaf0cf661c602a13520ab484af74f263b59ea625311d2d"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc0bc9edef180a175353023aacebeb161826d943b9f98ac6a0ec86fb00d6ad81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6aa3673f9204662d901a8ecdb8268dee40acd8e8a12ad9cbb93d0b1b5be04087"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6dd083f11718b8dc0132c65af29ac9a4a69724135f541c6fc0231061fd74c98a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a06fa80c77f7d1b7081ba73dd63bc273cdca173549ba11cd54864fd731b65dd6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eeb9b24f0b170061bf404474bd0fbc45f24ecdbb248dd39cfdd1582124e203ab"
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

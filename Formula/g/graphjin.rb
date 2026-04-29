class Graphjin < Formula
  desc "Build NodeJS / GO APIs in 5 minutes not weeks"
  homepage "https://graphjin.com/"
  url "https://github.com/dosco/graphjin/archive/refs/tags/v3.18.10.tar.gz"
  sha256 "c6f7e07e3a806a4b29c949209fb224b826519e0e765a9efcaa361dc18f60f3c0"
  license "Apache-2.0"
  head "https://github.com/dosco/graphjin.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1ffa32ba6837c89c07a0635b3171804c9eaf550756bdd7eaedbfeb0acfb8a8da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ceab43228cd58480c273e3ba1b441f190785a91b8538b1fad34b3653b4ff2c87"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78853f184e4e19eaa009a8abbf9c8ea3abe8ffce17c1ff389217297d536e77c2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a744185ad684d0bee447fc8dd88c8bc1ae7c1a70ce4090b80729b5ceae13e551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c695a7c11941a2f3474c68391b648b7a40b1843af7a70561d7d1b927f90c5c4c"
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

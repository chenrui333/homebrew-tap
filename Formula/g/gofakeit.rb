class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.8.2.tar.gz"
  sha256 "c663e0d0e9fe87fa2a390eae4a7071c7d26321e1fa568e3455b2fc62e3cf3346"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08e3ba25faf039e7fb6484b607c1ccf975372c96153586df94221478ffb3cac3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08e3ba25faf039e7fb6484b607c1ccf975372c96153586df94221478ffb3cac3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08e3ba25faf039e7fb6484b607c1ccf975372c96153586df94221478ffb3cac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ff9f6e6d96d458ad55b2be4fe1c7d0fea3f34264fd9e7dfda3938eea445550"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfe189a14be7da38ab6bf19c17d2491c3e2dc656d5f532b293c60a1001387078"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/gofakeit"
  end

  test do
    system bin/"gofakeit", "street"
    system bin/"gofakeit", "school"
  end
end

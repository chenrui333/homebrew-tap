class Gofakeit < Formula
  desc "Random fake data generator written in go"
  homepage "https://github.com/brianvoe/gofakeit"
  url "https://github.com/brianvoe/gofakeit/archive/refs/tags/v7.8.0.tar.gz"
  sha256 "f351f8de3368df27ffec3f29a536a3f46b7880fb058358e844013791b6ae1263"
  license "MIT"
  head "https://github.com/brianvoe/gofakeit.git", branch: "master"

  bottle do
    root_url "https://ghcr.io/v2/chenrui333/tap"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "01ad1fa045f685003bb6b9548ff38dbceec1b32ee7264320f83c5893eaa32d2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01ad1fa045f685003bb6b9548ff38dbceec1b32ee7264320f83c5893eaa32d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "01ad1fa045f685003bb6b9548ff38dbceec1b32ee7264320f83c5893eaa32d2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19f635d9a06bdbc42e69a31f954e994bcd5354214e70fc14e24eacce26606265"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a410526f115d6c101b22cca6d716cd89e618dd36a46b4ac198b50f076c62591"
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

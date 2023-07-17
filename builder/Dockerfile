FROM fedora:38 AS build-stage

ARG KERNEL_VERSION="6.4"
ARG PACKAGE_VERSION="6.4.3-200.fc38"
#TODO: kernel-local suffix arg

WORKDIR /tmp

COPY ./$KERNEL_VERSION ./kernel_patches
COPY ./kernel-local/kernel-local.my  ./kernel-local.custom
COPY ./builder/build.sh .

RUN ./build.sh

FROM scratch AS export-stage
COPY --from=build-stage /tmp/rpmbuild/SRPMS/ /

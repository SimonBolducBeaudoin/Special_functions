#pragma once

#include <pybind11/pybind11.h>
namespace py = pybind11;
using namespace pybind11::literals;

#include <special_functions.h>

void init_special_functions(py::module &m);